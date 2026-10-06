# Notch Teleprompter

**Um teleprompter minúsculo e instantâneo para macOS que fica logo abaixo da webcam, para você ler olhando direto para a lente.**

Sem abas, sem barra de URL, sem moldura de janela. Só uma faixa preta sem borda, colada no topo e no centro da tela (logo abaixo do notch do MacBook), sempre por cima e invisível em gravações de tela e videochamadas.

[Read in English](README.md)

## Por quê

Teleprompters web funcionam, mas ficam dentro de uma janela de browser, com barra de abas, barra de endereço e o texto no meio da tela. Você acaba olhando para o meio do monitor em vez de para a câmera, e isso aparece no vídeo.

Aqui o texto fica no único lugar que importa: logo abaixo da câmera. A primeira linha lida é a mais perto da lente, e o texto vai sumindo para baixo para o olho ficar em cima.

## Recursos

- **Colado na câmera:** posiciona sozinho no topo e no centro da tela com notch (ou da tela principal, se não houver notch), começando logo abaixo dele.
- **Sem borda e sempre por cima:** fica acima de qualquer app, inclusive em tela cheia e em todos os Spaces.
- **Escondido de gravação de tela:** Zoom, Meet, Teams, QuickTime e prints não enxergam (tecla `C` alterna).
- **Muito rápido:** janela nativa AppKit com `WKWebView`, rolagem em `requestAnimationFrame`. Abre na hora e não aparece no Dock.
- **Barra de controles** abaixo da área de leitura: play/pause, reiniciar, velocidade, tamanho do texto, altura e largura da janela, editor de roteiro.
- **Controle total pelo teclado**, para você não sair do roteiro enquanto grava.
- **Persistente:** roteiro e ajustes ficam salvos em `~/.teleprompter/`.
- **Pequeno e fácil de mexer:** cerca de 100 linhas de Swift e um HTML. Sem dependências e sem projeto Xcode.

## Instalação

Precisa de macOS 12+ e das Xcode Command Line Tools (`xcode-select --install`).

```bash
git clone https://github.com/valvesss/notch-teleprompter.git
cd notch-teleprompter
./build.sh
open Teleprompter.app
```

Dica: arraste `Teleprompter.app` para `/Applications` para abrir pelo Spotlight, Raycast ou Alfred.

## Uso

Aperte `E` para abrir o editor, cole o roteiro (Cmd+V) e aperte `Esc` para salvar e voltar. Aperte `Espaço` para começar.

| Tecla | Ação |
|---|---|
| `Espaço` | Play / pause |
| `↑` `↓` | Velocidade |
| `-` `=` | Tamanho do texto |
| `[` `]` | Altura da janela |
| `,` `.` | Largura da janela |
| `R` / `Home` | Voltar ao início |
| `PageUp` `PageDown` | Pular três linhas |
| `E` | Editar roteiro (`Esc` salva e fecha) |
| `C` | Mostrar ou esconder em gravação e compartilhamento de tela |
| `Esc` / `Cmd+Q` | Sair |

A roda do mouse rola o texto, e tudo também está na barra de controles.

## Observações

- O texto da interface está em português do Brasil, todo dentro do `index.html`.
- O app escolhe a tela que tem notch. Se você grava com webcam externa num monitor sem notch, ajuste a propriedade `screen` em `Teleprompter.swift`.

## Licença

[MIT](LICENSE)
