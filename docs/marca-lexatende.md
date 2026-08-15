# Marca LexAtende — inventário de personalização

Registro do que foi alterado no EvoCRM para aplicar a identidade LexAtende, e
por quê. Serve para orientar a resolução de conflitos em merges futuros: quando
o Git apontar conflito em um dos arquivos abaixo, este documento diz qual era a
intenção da alteração.

Arte-fonte e manual da marca: [`LexAtende-Logo/`](../LexAtende-Logo/).

## Como o repositório está organizado

Três repositórios privados, cada um com duas branches:

- **`main`** — espelho fiel do EvoCRM original, sem alteração alguma.
- **`lexatende`** — a marca aplicada.

`git diff main..lexatende` mostra, a qualquer momento, exatamente o que é nosso.

Atualizar (em cada repositório, submódulos antes do principal):

```
git fetch upstream
git checkout main && git merge upstream/main
git checkout lexatende && git merge main
```

## Paleta

Fonte oficial: `LexAtende-Logo/tokens-cores.css` e `paleta-cromatica.csv`.

| Papel | Cor |
|---|---|
| Marinho Institucional — primária, navegação, logo | `#04101E` |
| Marinho 700 — navegação em modo claro | `#153A60` |
| Azul Ação — etiquetas e tags | `#326EAE` |
| Turquesa Sinal — acento, botão primário em modo escuro | `#12A594` |
| Turquesa Texto — botão primário em modo claro | `#0B7A6E` |
| Turquesa Claro — foco e item ativo sobre marinho | `#3ECFBC` |
| Névoa — fundo em modo claro | `#F5F8FB` |
| Grafite — texto em modo claro | `#1C242E` |

### Restrições de contraste verificadas

Três decisões que parecem arbitrárias mas não são:

1. **Botão primário muda de cor entre os modos.** Branco sobre Turquesa Sinal dá
   3,11:1 — reprovado. Em modo claro o botão usa Turquesa Texto com branco
   (5,22:1, AA); em modo escuro, Turquesa Sinal com marinho (5,96:1, AA).
2. **O acento dentro da navegação é o Turquesa Claro, não o Sinal.** Sobre
   Marinho 700 o Sinal dá apenas 3,74:1; o Claro dá 6,02:1.
3. **Texto turquesa sobre fundo claro usa o Turquesa Texto.** O Sinal sobre
   branco dá 3,07:1 — serve para elemento gráfico, não para texto.

## Onde a marca vive

### Frontend (`evo-ai-frontend-community`)

| Arquivo | O que faz |
|---|---|
| `public/branding.css` | **Todo o tema.** Paleta, modo claro e escuro, correções estruturais |
| `index.html` | `<title>`, `lang="pt-BR"`, `<link>` para o branding.css |
| `src/assets/EVO_CRM.svg` | Logotipo do modo **escuro** (versão branca) |
| `src/assets/EVO_CRM_light.svg` | Logotipo do modo **claro** (versão marinho) |
| `public/favicon.svg`, `public/logo.svg` | Símbolo e logotipo servidos estaticamente |
| `src/components/AppLogo.tsx` | Texto alternativo |
| `src/components/layout/components/Header.tsx` | Logo maior + `forceTheme="dark"` |
| `src/components/layout/components/Sidebar.tsx` | Rodapé institucional oculto |
| `src/i18n/locales/*/` | Textos de marca, cor padrão de etiqueta |
| ~20 componentes | Cores que estavam fixas no código |

### CRM (`evo-ai-crm-community`)

| Arquivo | O que faz |
|---|---|
| `config/installation_config.yml` | Nome, URL e caminhos de logo (**semente**, veja abaixo) |
| `public/brand-assets/` | Logotipos usados pelo CRM |
| `public/manifest.json`, `browserconfig.xml` | PWA e ladrilho do Windows |
| `public/*.png`, `favicon.svg` | 30 ícones gerados a partir do símbolo |

## Decisões que não são óbvias

**`forceTheme="dark"` no Header.** O cabeçalho usa `bg-sidebar`, e a navegação é
marinho nos dois temas. Sem isso, em modo claro o componente escolheria o
logotipo marinho — marinho sobre marinho, invisível.

**Tokens `sidebar-*` redefinidos como conteúdo.** 109 componentes usam
`bg-sidebar`, `text-sidebar-foreground` e `border-sidebar-border` em conteúdo
comum — títulos, campos de busca, cartões. São 1.414 ocorrências. No tema
original isso não aparecia, porque barra lateral e fundo eram ambos escuros; com
fundo claro, gerava título invisível e busca escura no meio da página.

A correção está em `branding.css`: os tokens `sidebar-*` valem **conteúdo** por
padrão, e o marinho é reaplicado só nos containers de navegação
(`.bg-sidebar.border-r`, `.bg-sidebar.border-b`, `.\!bg-sidebar`), com
`:not(main *)` excluindo o conteúdo. Corrigir por variável, e não por classe, faz
as variantes de opacidade (`/70`, `/50`) acompanharem sozinhas.

**Tokens de conteúdo redefinidos dentro da navegação.** O `MenuItem` não usa
tokens `sidebar-*`: usa `text-muted-foreground`, `hover:bg-accent`, `bg-primary`
e `text-primary`. Sem redefinir esses dentro da navegação, os itens ficariam com
cor de conteúdo claro sobre fundo marinho.

**Botões com verde neon.** Quatro botões (MCP Servers, Macros, Convite em Massa)
trazem `bg-[#00ffa7]` e `text-black` fixos na classe. São reapontados por CSS em
`branding.css`, não editados na origem.

**Rodapé da barra lateral oculto, não removido.** Trocar uma classe é uma âncora
mínima; apagar o bloco exigiria casar dezenas de linhas de JSX. A linha de
copyright foi alterada nos 6 idiomas, então a titularidade não é exibida nem
fica embarcada no pacote.

## Ressalvas

**`installation_config.yml` é apenas semente.** Na primeira carga os valores vão
para o banco; depois disso o arquivo não manda mais. Em instalação em uso, nome,
logo e URL se alteram no painel (Super Admin → Settings).

**Cores padrão não repintam o que existe.** Etiquetas, tags e widgets já gravados
mantêm a cor do banco. A troca vale para os próximos.

**Alterar `branding.css` exige rebuild** do frontend, porque o arquivo vem da
imagem.

## Conformidade

- `LICENSE`, `NOTICE` e `TRADEMARKS.md` **preservados** em todos os repositórios.
  A Apache 2.0 exige manter os avisos de atribuição; remover marca da interface é
  diferente de remover arquivos de licença.
- Referências a "Evolution API" e "Evolution Go" na tela de canais são **nomes de
  integrações de terceiros** — uso nominativo, permitido pela Seção 2.3.
- Pendências de marca registradas em `LexAtende-Logo/LEIA-ME.md`, com destaque
  para a busca de anterioridade no INPI, não realizada.
- Há divergência entre a documentação pública do produtor (permissiva quanto a
  forks rebrandeados) e a condição 1(a) do `LICENSE` distribuído com o código.
  Convém confirmação por escrito do produtor.
