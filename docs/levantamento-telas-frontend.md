# Levantamento das telas do frontend — LexAtende

Data: 17/11/2026 · Branch: `lexatende` · Escopo: `evo-ai-frontend-community`

Levantamento feito por leitura do código, sem uso das telas no navegador. Os
números são contagens automáticas (grep) e servem para dimensionar os problemas,
não como medição exata. A prioridade de uso das telas é uma **premissa** e deve ser
confirmada pela equipe de atendimento.

---

## 1. Visão geral

| Item | Situação |
|---|---|
| Stack | React 19, Vite 6, Tailwind 4, Zustand, react-hook-form + zod, i18next |
| Tamanho | ~900 arquivos `.tsx`, ~83 mil linhas |
| Rotas | ~110 caminhos em `src/routes/index.tsx` (1.540 linhas, um único arquivo) |
| Componentes base | Pacote externo `@evoapi/design-system` **v0.0.6** (525 arquivos o importam). A pasta `src/components/ui` contém só um README |
| Tema da marca | `src/styles/globals.css` (variáveis `--lex-*` sobrepostas aos tokens do design system) |
| Idiomas | pt-BR, pt, en, es, fr, it — com testes de paridade |

---

## 2. Inventário de telas

Prioridade: **A** = uso diário pelo atendimento; **B** = uso frequente pela gestão;
**C** = configuração eventual; **—** = oculto no LexAtende.

### Atendimento (núcleo)

| Tela | Rota | Arquivo principal | Prior. | Observações |
|---|---|---|---|---|
| Conversas / caixa de entrada | `/conversations`, `/conversations/:id` | `pages/Customer/Chat/Chat.tsx` (1.067 l.) + `components/chat/*` | **A** | Tela mais crítica. `ChatSidebar` (1.104 l.), `MessageInput` (934 l.), contextos de conversa e mensagem com ~1.000 l. cada. Pouca adaptação a telas menores |
| Contatos | `/contacts`, `/contacts/:id` | `pages/Customer/Contacts/Contacts.tsx` (1.027 l.) | **A** | Apenas 3 breakpoints responsivos no arquivo |
| Ações agendadas | `/contacts/scheduled-actions` | `components/scheduledActions` | B | |
| Pipelines (kanban) | `/pipelines`, `/pipelines/:id` | `pages/Customer/Pipelines/PipelineKanban.tsx` (1.633 l.) | **A/B** | Arquivo muito grande; candidato a divisão |
| Dashboard | `/dashboard` | `pages/Customer/...` + `components/charts` | B | Primeira impressão do gestor |

### Marketing e automação

| Tela | Rota | Prior. | Observações |
|---|---|---|---|
| Campanhas | `/campaigns`, `/new`, `/:id/edit` | B | Ativada recentemente (Evo Flow) |
| Segmentos | `/settings/segments/*` | B | `SegmentConditionEditor.tsx` com 1.395 l. |
| Automações | `/automation/*` | C | Editor em fluxo (`@xyflow/react`) |
| Jornadas | `/journeys`, `/journey/:id/flow` | — | Oculto no menu; ainda assim é a área com mais cores fixas (781) |

### Agentes de IA

| Tela | Rota | Prior. | Observações |
|---|---|---|---|
| Lista e edição de agentes | `/agents/list`, `/agents/new`, `/agents/:id/edit` | C | `AgentEditPage` (1.047 l.), `GeneralTab` (1.157 l.) |
| Ferramentas e MCP próprios | `/agents/custom-tools/*`, `/agents/custom-mcp-servers/*` | C | Rotas duplicadas também em `/settings/custom-*` |

### Canais

| Tela | Rota | Prior. | Observações |
|---|---|---|---|
| Lista e criação de canais | `/channels`, `/channels/new` | B | |
| Configurações do canal | `/channels/:id/settings` | B | `ConfigurationForm.tsx` com **2.752 l.** (maior arquivo) e textos fixos em português fora do i18n |

### Configurações (16 subitens no menu)

Conta, Usuários, Equipes, Etiquetas, Atributos, Segmentos, Respostas prontas,
Modelos de mensagem, Macros, Formulários CRM, Páginas de chat, Templates,
Integrações (+12 subtelas), Tokens de acesso, Perfis de acesso (RBAC), Admin. Todos **C**,
exceto Usuários, Equipes, Etiquetas e Respostas prontas (**B**).

### Fora do layout principal

| Grupo | Rotas | Observações |
|---|---|---|
| Autenticação | `/login`, `/auth/*`, `/change-password` | Já personalizada (tela 60/40, `LoginShowcase`) |
| Setup / onboarding | `/setup`, `/setup/onboarding` | |
| Perfil | `/profile/:section?` | `Profile.tsx` com 1.297 l. |
| Públicas | `/chat/:slug`, `/f/:slug`, `/survey/responses/:uuid`, `/widget` | Visto pelo **cliente final** do escritório. `Widget/index.tsx` com 1.783 l. e cores da marca escritas direto no código |
| Callbacks OAuth | 17 rotas `/<serviço>/callback` | Sem interface relevante |
| Outras | `/marketplace`, `/tutorials`, `/documentation`, `/dashboard-app/:id` | Avaliar se fazem sentido no LexAtende |
| Removidas | `/products`, `/products/import` | Retornam 404 (decisão registrada em `docs/marca-lexatende.md`) |

---

## 3. Problemas transversais

| # | Problema | Evidência | Impacto |
|---|---|---|---|
| 1 | **Cores fora do tema.** Classes Tailwind cruas (`text-red-500`, `bg-blue-50`, `text-gray-500`…) ignoram a paleta LexAtende | ~3.570 ocorrências, contra ~5.360 usos de tokens semânticos. Concentração: journey 781, channels 574, integrations 405, pages/Customer 282, ai_agents 232, chat 205 | Visual inconsistente; o modo escuro depende de ~1.260 sobrescritas `dark:` manuais |
| 2 | **Design system externo e imaturo** (`v0.0.6`) | 525 arquivos dependem dele; não há camada local de componentes | Mudar botão, campo ou modal exige sobrescrever CSS ou trocar o pacote |
| 3 | **Arquivos gigantes** | 20 arquivos com mais de 900 linhas | Mudanças visuais arriscadas e lentas; mais conflitos com o upstream |
| 4 | **Medidas fixas em px** | ~200 `w-[…px]`/`h-[…px]` | Prejudica telas menores e a escala fluida já adotada no login |
| 5 | **Responsividade fraca nas telas A** | Chat 8, Contatos 3, ChatSidebar 3 breakpoints; só 4 arquivos usam `isMobile` | Uso em notebook pequeno ou celular comprometido |
| 6 | **Acessibilidade** | 42 botões só com ícone sem `aria-label`; 35 `<button>` nativos fora do DS | Leitores de tela; foco inconsistente |
| 7 | **Confirmações nativas** | 13 `window.confirm`/`alert` | Destoa visualmente; não segue o tema |
| 8 | **Textos fora do i18n** | ~35 strings fixas detectadas (ex.: `ConfigurationForm.tsx:1539`, `ViewTokenModal.tsx:145` em inglês) | Mistura de idiomas na interface |
| 9 | **Estados de carregamento e vazio sem padrão** | 258 `Loader2` (spinner) contra 91 `Skeleton`; 42 arquivos com estado vazio | Experiência diferente a cada tela |
| 10 | **Documentação desatualizada** | `docs/marca-lexatende.md` ainda aponta `public/branding.css`, removido no commit `31b3de2f` (tema está em `src/styles/globals.css`) | Orientação errada em merges futuros |

---

## 4. Recomendação de ordem de trabalho

1. **Fundação (baixo conflito com o upstream).**
   - Criar a camada `src/components/ui` (prevista no README e hoje vazia) com
     envoltórios dos componentes do `@evoapi/design-system`: Button, Input,
     Select, Dialog, ConfirmDialog, EmptyState, PageHeader, Skeleton e DataTable.
   - Definir tokens semânticos de status (`success`, `warning`, `danger`, `info`)
     em `globals.css` para substituir `red/green/blue-*`.
   - Corrigir a documentação da marca (item 10).
2. **Tela piloto: Conversas.** Aplicar a fundação, revisar a densidade, a
   hierarquia e a responsividade, e dividir os componentes grandes apenas onde
   for necessário.
3. **Contatos e Pipelines.** Mesmo padrão: tabela, cabeçalho de página e
   estados vazios e de carregamento.
4. **Dashboard e telas públicas** (widget, chat page, formulário): é o que o
   cliente final vê; remover as cores fixas de lá.
5. **Configurações.** Reorganizar os 16 subitens em grupos (Equipe, Atendimento,
   Integrações, Segurança) e trocar os `window.confirm`.
6. **Varredura contínua** das cores cruas, área por área, começando pelas mais
   visíveis (chat, canais); Jornadas fica por último por estar oculta.

### Pontos a decidir antes

- **Upstream:** continuar acompanhando o EvoCRM (preferir camadas e arquivos
  novos) ou assumir o fork (liberdade para reescrever as telas)?
- **Validação de uso:** confirmar com o atendimento quais telas são de fato as
  mais usadas e quais incomodam mais.
- **Telas a remover ou ocultar** além de Produtos e Jornadas (Marketplace,
  Tutoriais, Documentação, integrações irrelevantes ao escritório).
