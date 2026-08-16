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
| `src/pages/Auth/Auth.tsx` | Tela de entrada 60/40, **sem recuperação de senha** |
| `src/pages/Auth/LoginShowcase.tsx` | Painel institucional da entrada (arte SVG gerada) |
| `src/assets/EVO_CRM.svg` | Logotipo do modo **escuro** (versão branca) |
| `src/assets/EVO_CRM_light.svg` | Logotipo do modo **claro** (versão marinho) |
| `public/favicon.svg`, `public/logo.svg` | Símbolo e logotipo servidos estaticamente |
| `src/components/AppLogo.tsx` | Texto alternativo |
| `src/components/layout/components/Header.tsx` | Largura da navegação, logo maior, `forceTheme="dark"` |
| `src/components/layout/components/Sidebar.tsx` | Largura da navegação, rodapé institucional oculto |
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

**Largura da navegação: `w-72`, não o `w-56` original.** O valor de origem
(224px) cortava "Agentes de IA" em duas linhas e apertava "Configurações".

A largura aparece em **dois lugares que precisam casar** — `Sidebar.tsx:187` e
`Header.tsx:236`. Alterar só um desalinha o logotipo em relação ao menu. Se um
merge trouxer conflito em um deles, confira o outro.

Contas, para quem for ajustar: `w-72` são 288px; menos o respiro lateral
(`px-4`), sobram 256px. O logotipo a `h-12` ocupa 190px e o botão de recolher,
32px — total de 222px, com 34px de folga. A proporção do logotipo é 3,97:1, e o
`max-w` precisa acompanhar a altura (`h-12` → `max-w-52`), senão a imagem é
achatada — distorção que o manual da marca proíbe.

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

**Tela de entrada em 60/40, com painel institucional próprio.** A tela original
era um cartão centralizado com três abas — Entrar, Cadastrar, Recuperar. Agora
são duas colunas (`lg:grid-cols-5`, 3 + 2 = exatamente 60/40): à esquerda, o
painel de marca; à direita, o formulário.

**A tela ignora o tema do usuário: é sempre clara.** Marinho à esquerda, Névoa à
direita, mesmo com o produto em modo escuro. Quem faz isso é a classe
`.lex-login-light`, em `globals.css`, aplicada no container da tela.

Duas armadilhas que essa classe precisou contornar, e que voltarão a morder quem
mexer nela:

- **Redefinir a variável não muda o texto herdado.** O `<body>` já resolveu
  `color` com o valor do tema escuro; `<h1>`, `<label>` e `<input>`, que não
  declaram cor própria, herdam esse valor **já computado**, não a variável. Sem
  a linha `color: var(--foreground)` no container, título e rótulos saem brancos
  sobre fundo claro — invisíveis. Este defeito existiu e foi corrigido; não o
  reintroduza removendo a linha por parecer redundante.
- **A variante `dark:` não é resolvida por variável.** Ela depende do ancestral
  `.dark` no `<html>`, fora do alcance do container. Só um caso sobra visível: o
  `dark:bg-input/30` do campo do design system, neutralizado por uma regra
  explícita para `[data-slot='input']`.

A lista do seletor de idioma abre em portal, no `<body>` — fora do container.
Por isso o `SelectContent` recebe a mesma classe.

Três consequências que não se percebem lendo só o `Auth.tsx`:

1. **A recuperação de senha saiu da tela, não do sistema.** O formulário e a
   chamada a `forgotPassword()` foram removidos do componente, mas o serviço
   (`services/auth/authService.ts`) e a rota `/auth/reset-password` continuam
   de pé — links já enviados por e-mail seguem funcionando. Reativar exige
   reconstruir a UI, não o back-end.
2. **O painel é marinho nos dois temas**, pelo mesmo motivo do Header: o
   logotipo servido ali é a versão branca. Só o lado do formulário acompanha
   claro/escuro.
3. **A arte é SVG gerado, não fotografia** — ~2 KB, nítida em qualquer
   densidade, sem licença de imagem, e usa os hexadecimais exatos da paleta. O
   ponto de troca por foto está comentado dentro de `<Backdrop />`; a camada
   `url(#lex-fade)` deve ser mantida, porque é ela que garante o contraste do
   texto sobre a imagem.

A marca d'água do painel reaproveita as coordenadas originais das duas barras
de `LexAtende-Logo/svg/lexatende-simbolo-branco.svg` — o símbolo é desenhado em
torno de (65, −65), por isso a constante `WATERMARK_SCALE` aparece também no
`translate`. Mudar a escala sem recalcular o translate desloca a marca.

**O seletor de idioma sai da entrada, e só dela.** Setup, Onboarding e
Configurações da Conta continuam trocando de idioma normalmente, e
`src/i18n/config.ts` **não foi tocado** — a detecção por navegador e a memória
em `localStorage` seguem intactas.

Houve uma tentativa de fixar a interface em pt-BR aqui, revertida: o
`defaultLocale` do projeto é `en`, e fixar o idioma na inicialização faria a
escolha feita nas Configurações da Conta se perder a cada recarga. Quem quiser
que uma máquina com navegador em inglês abra em português deve mudar o
`defaultLocale`, não curto-circuitar a detecção.

**O aviso do reCAPTCHA foi retirado da tela, a pedido.** A proteção continua
ativa — `executeRecaptcha()` segue sendo chamado antes de cada envio; o que saiu
foi só o texto. Fica registrado que os termos do Google pedem que esse aviso
apareça quando o selo está oculto: é uma pendência de conformidade a decidir,
não um efeito colateral despercebido.

Os textos do painel vivem em `auth.showcase.*` nos **seis** idiomas, e são
propositalmente curtos: título e três rótulos, sem descritivos. Texto a mais ali
compete com o formulário. As chaves mortas da tela antiga (`auth.tabs`,
`auth.login.forgotPasswordLink`, o bloco `auth.forgotPassword` e os dois
`protectedByRecaptcha`) foram removidas — `i18n-parity.spec.ts` exige que pt-BR
espelhe EN, então acrescentar ou remover chave aqui é sempre nos seis arquivos.

**Botões com verde neon.** Quatro botões (MCP Servers, Macros, Convite em Massa)
trazem `bg-[#00ffa7]` e `text-black` fixos na classe. São reapontados por CSS em
`branding.css`, não editados na origem.

**Rodapé da barra lateral oculto, não removido.** Trocar uma classe é uma âncora
mínima; apagar o bloco exigiria casar dezenas de linhas de JSX. A linha de
copyright foi alterada nos 6 idiomas, então a titularidade não é exibida nem
fica embarcada no pacote.

**Produtos foi retirado do produto.** Um escritório de advocacia não mantém
catálogo. A remoção é em três pontos, e vale saber por que são três: o item da
barra lateral em `menuItems.ts`, as rotas `/products` e `/products/import` em
`routes/index.tsx`, e a aba **Produtos dentro do editor de Agentes de IA**
(`AgentEditSidebar.tsx`) — esta última não é protegida por permissão, então
qualquer solução via RBAC a deixaria visível e vazia.

Duas escolhas conscientes aqui:

- **Código, não permissão.** Revogar `products` pela tela de Papéis funcionaria
  para o menu e as rotas sem tocar em código, mas é *dado*: não acompanha o
  repositório, precisa ser refeito em cada instalação e um papel novo pode vir
  com a permissão ligada.
- **A aba do agente foi desligada com `show: false`, não apagada.** É diferença
  de uma linha, que o merge reconcilia sozinho; apagar o bloco criaria conflito
  sempre que o upstream mexesse na lista. `activeMenu` nasce em `'profile'` e só
  muda por clique nessa lista, então desligar ali torna a aba inalcançável.

As páginas, componentes e serviços de Produtos **continuam no repositório**,
inertes e sem rota — reduz a diferença com o upstream e permite voltar atrás. O
teste `menuItems.lexatende.spec.ts` (arquivo novo, nunca conflita) falha se uma
atualização reintroduzir o item.

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
