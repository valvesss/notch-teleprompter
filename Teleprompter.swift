import Cocoa
import WebKit

// Janela sem borda, sempre por cima, colada no topo da tela (abaixo do notch/câmera).
final class Panel: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    // Deixa a janela ocupar a área da barra de menus em vez de ser empurrada pra baixo dela.
    override func constrainFrameRect(_ r: NSRect, to s: NSScreen?) -> NSRect { r }
}

final class App: NSObject, NSApplicationDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    let dir = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".teleprompter")
    var cfgURL: URL { dir.appendingPathComponent("config.json") }
    var scriptURL: URL { dir.appendingPathComponent("script.txt") }
    var win: Panel!
    var web: WKWebView!

    // Tela da câmera: a com notch; senão a principal.
    var screen: NSScreen {
        NSScreen.screens.first { $0.safeAreaInsets.top > 0 } ?? NSScreen.main ?? NSScreen.screens[0]
    }

    func applicationDidFinishLaunching(_ n: Notification) {
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        buildMenu()

        let conf = WKWebViewConfiguration()
        conf.userContentController.add(self, name: "tp")
        web = WKWebView(frame: .zero, configuration: conf)
        web.setValue(false, forKey: "drawsBackground")
        web.navigationDelegate = self

        win = Panel(contentRect: NSRect(x: 0, y: 0, width: 760, height: 150),
                    styleMask: [.borderless], backing: .buffered, defer: false)
        win.contentView = web
        win.isOpaque = false
        win.backgroundColor = .clear
        win.hasShadow = false
        win.level = .statusBar
        win.sharingType = .none  // invisível em gravação/compartilhamento de tela (tecla C alterna)
        win.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]

        let html = Bundle.main.url(forResource: "index", withExtension: "html")!
        web.loadFileURL(html, allowingReadAccessTo: html.deletingLastPathComponent())
    }

    func webView(_ w: WKWebView, didFinish _: WKNavigation!) {
        var cfg = (try? String(contentsOf: cfgURL, encoding: .utf8)) ?? "{}"
        if (try? JSONSerialization.jsonObject(with: Data(cfg.utf8))) == nil { cfg = "{}" }
        let script = (try? String(contentsOf: scriptURL, encoding: .utf8)) ?? ""
        let arr = try! JSONSerialization.data(withJSONObject: [script])
        w.evaluateJavaScript("init(\(cfg), \(String(decoding: arr, as: UTF8.self))[0])")
        win.makeKeyAndOrderFront(nil)
        win.makeFirstResponder(web)
        NSApp.activate(ignoringOtherApps: true)
    }

    func place(w: CGFloat, h: CGFloat) {
        let s = screen
        let f = s.frame
        let top = s.safeAreaInsets.top  // altura do notch; 0 sem notch
        win.setFrame(NSRect(x: f.midX - w / 2, y: f.maxY - top - h, width: w, height: h), display: true)
    }

    func userContentController(_ c: WKUserContentController, didReceive m: WKScriptMessage) {
        guard let b = m.body as? [String: Any], let t = b["type"] as? String else { return }
        func num(_ k: String, _ d: CGFloat) -> CGFloat { (b[k] as? NSNumber).map { CGFloat($0.doubleValue) } ?? d }
        switch t {
        case "frame": place(w: num("w", 760), h: num("h", 150))
        case "save":
            if let cfg = b["cfg"], let d = try? JSONSerialization.data(withJSONObject: cfg) { try? d.write(to: cfgURL) }
            if let s = b["script"] as? String { try? s.write(to: scriptURL, atomically: true, encoding: .utf8) }
        case "capture": win.sharingType = (b["on"] as? Bool == true) ? .readOnly : .none
        case "quit": NSApp.terminate(nil)
        default: break
        }
    }

    // Sem menu de Edição, Cmd+V/C/A não funcionam dentro do WKWebView.
    func buildMenu() {
        let main = NSMenu()
        let appItem = NSMenuItem(); main.addItem(appItem)
        let app = NSMenu()
        app.addItem(withTitle: "Sair", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appItem.submenu = app
        let editItem = NSMenuItem(); main.addItem(editItem)
        let edit = NSMenu(title: "Editar")
        edit.addItem(withTitle: "Desfazer", action: Selector(("undo:")), keyEquivalent: "z")
        edit.addItem(withTitle: "Refazer", action: Selector(("redo:")), keyEquivalent: "Z")
        edit.addItem(.separator())
        edit.addItem(withTitle: "Cortar", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        edit.addItem(withTitle: "Copiar", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        edit.addItem(withTitle: "Colar", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        edit.addItem(withTitle: "Selecionar tudo", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        editItem.submenu = edit
        NSApp.mainMenu = main
    }
}

let app = NSApplication.shared
let delegate = App()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
