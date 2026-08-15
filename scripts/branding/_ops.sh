#!/usr/bin/env bash
# =============================================================================
# LexAtende — catálogo declarativo de operações de marca
# =============================================================================
# Este arquivo NÃO executa nada por conta própria. Ele apenas declara O QUE
# precisa ser feito. Quem decide o COMO são os dois scripts que o carregam:
#
#   apply-branding.sh  — implementa as operações escrevendo nos arquivos
#   check-branding.sh  — implementa as mesmas operações apenas verificando
#
# Manter o catálogo em um único lugar garante que a verificação nunca fique
# defasada em relação à aplicação.
#
# Operações disponíveis:
#   op_copy       ORIGEM DESTINO              — copia arquivo
#   op_subst      ARQUIVO ANTIGO NOVO         — troca literal de texto
#   op_subst_glob PADRÃO ANTIGO NOVO          — idem, em vários arquivos
#   op_inject     ARQUIVO ÂNCORA LINHA        — insere LINHA antes da ÂNCORA
# =============================================================================

FE="evo-ai-frontend-community"
CR="evo-ai-crm-community"
BR="branding"

branding_ops() {

  # ===========================================================================
  # FRONTEND — evo-ai-frontend-community
  # ===========================================================================

  # --- Assets servidos estaticamente (public/) ------------------------------
  # Não passam pelo empacotador: trocar estes arquivos NÃO exige rebuild.
  # O símbolo traz bloco de fundo próprio, então serve de favicon sobre
  # qualquer cor de aba do navegador.
  op_copy "$BR/assets/lexatende-simbolo-marinho.svg"   "$FE/public/favicon.svg"
  op_copy "$BR/assets/lexatende-logotipo-marinho.svg"  "$FE/public/logo.svg"
  op_copy "$BR/branding.css"                           "$FE/public/branding.css"

  # --- Assets empacotados pelo Vite (src/assets/) ---------------------------
  # ALTERNÂNCIA DE LOGO POR TEMA. O componente AppLogo escolhe entre estes dois
  # arquivos conforme o tema ativo. Mantemos os nomes originais de propósito:
  # assim o AppLogo.tsx continua intacto, sem nenhuma alteração de código.
  #
  # Regra do manual: versão marinho sobre branco/Névoa; versão branca sobre
  # Marinho Institucional. Ambas têm fundo transparente e o "x" em Turquesa.
  # Trocar estes arquivos EXIGE rebuild da imagem do frontend.
  op_copy "$BR/assets/lexatende-logotipo-branco.svg"   "$FE/src/assets/EVO_CRM.svg"
  op_copy "$BR/assets/lexatende-logotipo-marinho.svg"  "$FE/src/assets/EVO_CRM_light.svg"

  # --- index.html -----------------------------------------------------------
  op_subst "$FE/index.html" "<title>Evo CRM</title>" "<title>LexAtende</title>"
  op_subst "$FE/index.html" '<html lang="en">'       '<html lang="pt-BR">'
  # A âncora inclui a indentação de propósito, para a linha injetada sair
  # alinhada com o restante do <head>.
  op_inject "$FE/index.html" "  </head>" \
    '    <link rel="stylesheet" href="/branding.css" />'

  # --- Texto alternativo do logotipo (acessibilidade) -----------------------
  op_subst "$FE/src/components/AppLogo.tsx" \
    "alt = 'EVO CRM'" "alt = 'LexAtende'"

  # --- Textos de interface (i18n, todos os idiomas) -------------------------
  op_subst_glob "$FE/src/i18n/locales/*/*.json" "Evo CRM" "LexAtende"

  # Retira a titularidade da Evolution Foundation do texto de copyright. O
  # rodapé onde ele aparecia está oculto (veja abaixo), mas a string seguiria
  # embarcada no pacote — e é justamente a linha de copyright que o
  # TRADEMARKS.md trata como elemento protegido.
  op_subst_glob "$FE/src/i18n/locales/*/layout.json" "Evolution Foundation" "LexAtende"

  # --- Barra lateral: logotipo maior ----------------------------------------
  # CUIDADO AO AUMENTAR MAIS: a faixa da barra lateral tem 224px (w-56) e, com
  # o respiro lateral (px-4), sobram 192px. O logotipo a h-10 ocupa ~159px e o
  # botão de recolher, 32px — total de ~191px. Já está no limite. Para crescer
  # além disso é preciso alargar a barra lateral junto (w-56 → w-64).
  # A proporção do logotipo é 3,97:1; o max-w precisa acompanhar a altura,
  # senão a imagem é achatada — distorção que o manual da marca proíbe.
  #
  # O `forceTheme="dark"` não é capricho: o cabeçalho usa `bg-sidebar`
  # (Header.tsx:90) e a barra lateral é marinho NOS DOIS TEMAS. Sem isso, em
  # modo claro o AppLogo escolheria a versão marinho — logotipo marinho sobre
  # fundo marinho, ou seja, invisível. Aqui a variante branca é fixa; a
  # alternância por tema segue valendo nas telas de fundo claro (login,
  # setup, carregamento, callbacks).
  op_subst "$FE/src/components/layout/components/Header.tsx" \
    'className="h-8 max-w-32"' 'className="h-10 max-w-40" forceTheme="dark"'

  # --- Barra lateral: rodapé institucional oculto ---------------------------
  # Remove da vista o bloco com nome, copyright, "Documentation" e
  # "I need support".
  # NOTA: o bloco fica oculto (display:none), não excluído do código. Foi uma
  # escolha deliberada — trocar uma classe é uma âncora minúscula, que
  # sobrevive a atualizações; apagar o bloco inteiro exigiria casar dezenas de
  # linhas de JSX e quebraria na primeira alteração do EvoCRM.
  # A mesma classe existe em Header.tsx e ProfileMenu.tsx, onde envolve o
  # seletor de tema — por isso a substituição é restrita a este arquivo.
  op_subst "$FE/src/components/layout/components/Sidebar.tsx" \
    'className="p-4 border-t border-sidebar-border"' \
    'className="hidden"'

  # --- Lista de exceções do teste anti-vazamento de tradução ----------------
  # O projeto tem um teste (EVO-1430) que acusa strings idênticas entre EN e
  # pt-BR. Nomes de marca são exceção legítima e precisam ser declarados aqui,
  # senão a suíte de testes quebra.
  op_subst "$FE/src/i18n/locales/_lib/allowlist.ts" \
    "'Evo CRM', 'EvoAI'" "'Evo CRM', 'LexAtende', 'EvoAI'"

  # ===========================================================================
  # FRONTEND — cores escritas direto no código
  # ===========================================================================
  # As cores abaixo NÃO passam pelos tokens do tema: estão fixas no JSX, então
  # nenhuma sobreposição de variável CSS as alcança. Os botões que usam classe
  # utilitária foram resolvidos em branding/branding.css; o que sobra aqui são
  # estilos embutidos e valores em código, que só mudam na origem.
  #
  # A cor é escolhida pelo PAPEL de cada elemento, não uma cor única para tudo:
  #
  #   Turquesa Sinal #12A594 — ação primária e acento
  #   Marinho Instit. #04101E — widget de chat (é o que o cliente final vê;
  #                             branco sobre marinho dá 19,13:1, AAA — sobre
  #                             turquesa daria 3,11:1, reprovado)
  #   Azul Ação      #326EAE — etiquetas e tags (a paleta já o reserva para
  #                             elementos interativos, e assim não compete
  #                             visualmente com o botão primário)

  # --- Verde neon do Evo (#00ffa7) → Turquesa Sinal -------------------------
  # No onboarding são 7 pontos no mesmo arquivo (bordas, marca de seleção,
  # estado selecionado), vários deles em estilo embutido.
  op_subst "$FE/src/pages/Setup/OnboardingPage.tsx" "#00ffa7" "#12A594"
  # Cor de reserva do estágio de pipeline, quando o estágio não define a sua.
  op_subst "$FE/src/components/chat/conversation/ConversationBadges.tsx" \
    "#00ffa7" "#12A594"

  # --- Azul do Chatwoot (#1f93ff) → Azul Ação, no papel de etiqueta ---------
  # ATENÇÃO: isto muda apenas o PADRÃO de novas etiquetas. Etiquetas e tags já
  # gravadas no banco mantêm a cor que têm — não são repintadas.
  op_subst_glob "$FE/src/i18n/locales/*/labels.json" "#1f93ff" "#326EAE"
  op_subst "$FE/src/components/labels/LabelModal.tsx"                    "#1f93ff" "#326EAE"
  op_subst "$FE/src/components/contacts/ContactTagsList.tsx"             "#1f93ff" "#326EAE"
  op_subst "$FE/src/components/chat/conversation/ConversationBadges.tsx" "#1f93ff" "#326EAE"
  op_subst "$FE/src/components/channels/settings/AgentBotConfigurationForm.tsx" \
    "#1f93ff" "#326EAE"

  # --- Widget de chat → Marinho Institucional -------------------------------
  # Mesma ressalva: só afeta widgets novos; os já configurados guardam a cor
  # escolhida no banco.
  op_subst "$FE/src/services/widget/widgetService.ts"                "#1f93ff" "#04101E"
  op_subst "$FE/src/components/channels/settings/WidgetBuilderForm.tsx" "#1f93ff" "#04101E"
  op_subst "$FE/src/components/widget/Header.tsx"                    "#1f93ff" "#04101E"
  op_subst "$FE/src/components/widget/PreChatForm.tsx"               "#1f93ff" "#04101E"
  op_subst "$FE/src/components/widget/StartNewConversationButton.tsx" "#1f93ff" "#04101E"
  op_subst "$FE/src/components/chatPages/ChatPageModal.tsx"          "#1f93ff" "#04101E"

  # --- Verde-água do Evo (#00d4aa) → Marinho, no papel de widget ------------
  # Terceira cor de marca do Evo, concentrada no widget.
  # NOTA: src/utils/colorUtils.ts também cita #00d4aa, mas apenas em exemplos
  # de comentário de documentação — não afeta a interface e fica como está.
  op_subst "$FE/src/pages/Widget/index.tsx"                       "#00d4aa" "#04101E"
  op_subst "$FE/src/components/widget/ChatScreen.tsx"             "#00d4aa" "#04101E"
  op_subst "$FE/src/components/widget/MessageList.tsx"            "#00d4aa" "#04101E"
  op_subst "$FE/src/components/widget/Composer.tsx"               "#00d4aa" "#04101E"
  op_subst "$FE/src/components/widget/EmailTranscriptButton.tsx"  "#00d4aa" "#04101E"
  op_subst "$FE/src/hooks/widget/useWidgetChat.ts"                "#00d4aa" "#04101E"

  # --- Paleta de sugestões de cor do widget ---------------------------------
  # Âncoras distintas de propósito: no mesmo arquivo há a cor padrão (linha do
  # widgetColor) e as amostras do seletor, que têm papéis diferentes.
  op_subst "$FE/src/components/channels/settings/helpers/widgetHelpers.ts" \
    "  widgetColor: '#1f93ff'," "  widgetColor: '#04101E',"
  op_subst "$FE/src/components/channels/settings/helpers/widgetHelpers.ts" \
    "'#1f93ff', // Default blue" "'#04101E', // Marinho Institucional (LexAtende)"
  op_subst "$FE/src/components/channels/settings/helpers/widgetHelpers.ts" \
    "'#00d4aa', // Evolution green" "'#12A594', // Turquesa Sinal (LexAtende)"

  # ===========================================================================
  # CRM — evo-ai-crm-community
  # ===========================================================================

  # --- Logotipos referenciados pelo installation_config ---------------------
  op_copy "$BR/assets/lexatende-logotipo-marinho.svg" "$CR/public/brand-assets/logo.svg"
  op_copy "$BR/assets/lexatende-logotipo-branco.svg" "$CR/public/brand-assets/logo_dark.svg"
  op_copy "$BR/assets/lexatende-simbolo-marinho.svg"  "$CR/public/brand-assets/logo_thumbnail.svg"
  op_copy "$BR/assets/lexatende-simbolo-marinho.svg"  "$CR/public/favicon.svg"

  # --- Semente de configuração ----------------------------------------------
  # ATENÇÃO: estes valores são apenas a SEMENTE inicial. Depois da primeira
  # carga eles passam a viver no banco de dados e o arquivo deixa de mandar.
  # Para alterar em instalação já em uso, mexa no painel de administração
  # (Super Admin > Settings), não aqui.
  op_subst "$CR/config/installation_config.yml" \
    "  value: 'Evolution'" "  value: 'LexAtende'"
  op_subst "$CR/config/installation_config.yml" \
    "  value: 'https://evoai.app'" "  value: 'https://lexatende.com.br'"

  # --- PWA / ícones de sistema ----------------------------------------------
  op_subst "$CR/public/manifest.json" '"name": "Evolution"'       '"name": "LexAtende"'
  op_subst "$CR/public/manifest.json" '"short_name": "Evolution"' '"short_name": "LexAtende"'
  op_subst "$CR/public/manifest.json" '"background_color": "#1f93ff"' '"background_color": "#04101E"'
  op_subst "$CR/public/manifest.json" '"theme_color": "#1f93ff"'      '"theme_color": "#04101E"'
  op_subst "$CR/public/browserconfig.xml" \
    "<TileColor>#ffffff</TileColor>" "<TileColor>#04101E</TileColor>"

  # --- Ícones rasterizados ---------------------------------------------------
  # Gerados por ./scripts/branding/generate-icons.sh a partir do símbolo SVG.
  # Se aparecerem como "origem inexistente", é sinal de que o gerador ainda
  # não rodou nesta máquina.
  local icon
  for icon in \
    favicon-16x16.png favicon-32x32.png favicon-96x96.png favicon-512x512.png \
    favicon-badge-16x16.png favicon-badge-32x32.png favicon-badge-96x96.png \
    android-icon-36x36.png android-icon-48x48.png android-icon-72x72.png \
    android-icon-96x96.png android-icon-144x144.png android-icon-192x192.png \
    apple-icon-57x57.png apple-icon-60x60.png apple-icon-72x72.png \
    apple-icon-76x76.png apple-icon-114x114.png apple-icon-120x120.png \
    apple-icon-144x144.png apple-icon-152x152.png apple-icon-180x180.png \
    apple-icon.png apple-icon-precomposed.png \
    apple-touch-icon.png apple-touch-icon-precomposed.png \
    ms-icon-70x70.png ms-icon-144x144.png ms-icon-150x150.png ms-icon-310x310.png
  do
    op_copy "$BR/generated/$icon" "$CR/public/$icon"
  done
}
