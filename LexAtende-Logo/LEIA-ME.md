# LexAtende — Logotipo (rota "Troca") e paleta cromática

Rascunho técnico de identidade visual. Sujeito a revisão e validação antes do uso definitivo.

## Conceito

Logotipo em wordmark puro. O "x" de *Lex* é substituído por duas hastes cruzadas —
a haste ascendente em Turquesa Sinal — como leitura de troca de mensagens embutida
na própria palavra. O símbolo isolado (as duas hastes em bloco arredondado) serve
como ícone de aplicativo, avatar de WhatsApp Business e favicon.

Cor principal: **#04101E** (Marinho Institucional). Detalhe do "x": **#12A594** (Turquesa Sinal).

## Arquivos

### `/svg` — arquivos-fonte (vetorial, escala livre)

| Arquivo | Descrição |
|---|---|
| `lexatende-logotipo-marinho.svg` | Texto em #04101E, detalhe do "x" em #12A594. Fundo transparente. **Versão principal.** |
| `lexatende-logotipo-branco.svg` | Texto em branco, detalhe do "x" em #12A594. Fundo transparente. |
| `lexatende-logotipo-negativo-fundo-marinho.svg` | Versão branca com fundo marinho embutido no arquivo. |
| `lexatende-logotipo-mono-marinho.svg` | Uma cor (#04101E). Impressão econômica, gravação, carimbo. |
| `lexatende-logotipo-mono-branco.svg` | Uma cor (branco), fundo transparente, para fundo escuro. |
| `lexatende-simbolo-*.svg` | Símbolo isolado, proporção 1:1, nas mesmas cinco variações. |

A tipografia já está convertida em curvas. Os arquivos não dependem de fonte instalada
e abrem em Illustrator, Figma, Inkscape ou Corel.

### `/png` — versões rasterizadas

Logotipo em 1200 px e 2400 px de largura; símbolo em 512 px e 1024 px.
Todas as versões têm fundo transparente, exceto a `negativo-fundo-marinho`.
Para outros tamanhos, exportar a partir do SVG — não ampliar o PNG.

### Paleta em formato reaproveitável

- `tokens-cores.css` — variáveis CSS para o front-end.
- `tokens-cores.json` — mesmas cores em JSON, com RGB e CMYK.
- `paleta-cromatica.csv` — planilha com todos os valores e o contraste sobre branco.

## Paleta cromática

### Escala marinho

| Cor | HEX | RGB | CMYK (referência) | Uso |
|---|---|---|---|---|
| Marinho Institucional | `#04101E` | 4 16 30 | 87 47 0 88 | **Primária.** Logotipo, títulos, fundos densos, navegação |
| Marinho 900 | `#081B30` | 8 27 48 | 83 44 0 81 | Superfícies elevadas em modo escuro |
| Marinho 800 | `#0D2845` | 13 40 69 | 81 42 0 73 | Cartões e blocos sobre fundo marinho |
| Marinho 700 | `#153A60` | 21 58 96 | 78 40 0 62 | Bordas em modo escuro, gráficos |
| Marinho 600 | `#225081` | 34 80 129 | 74 38 0 49 | Realces discretos e ilustrações |
| Azul Ação | `#326EAE` | 50 110 174 | 71 37 0 32 | Links, botões secundários, estados interativos |
| Marinho 400 | `#6092C7` | 96 146 199 | 52 27 0 22 | Ícones e apoio gráfico em fundo claro |
| Marinho 300 | `#9AB7D6` | 154 183 214 | 28 15 0 16 | Texto secundário sobre fundo marinho |
| Marinho 200 | `#C9D8E8` | 201 216 232 | 13 7 0 9 | Divisores e superfícies desativadas |
| Marinho 100 | `#E6EDF5` | 230 237 245 | 6 3 0 4 | Bordas e superfícies suaves |
| Névoa | `#F5F8FB` | 245 248 251 | 2 1 0 2 | Fundo de tela e de cartões |

### Acentos

| Cor | HEX | RGB | CMYK | Uso |
|---|---|---|---|---|
| Turquesa Sinal | `#12A594` | 18 165 148 | 89 0 10 35 | **Acento.** Detalhe do "x", botão primário, status de atendimento ativo |
| Turquesa Texto | `#0B7A6E` | 11 122 110 | 91 0 10 52 | Variante aprovada para texto e ícones finos sobre fundo claro |
| Turquesa Claro | `#3ECFBC` | 62 207 188 | 70 0 9 19 | Realce sobre fundo marinho, gráficos, foco |
| Âmbar Institucional | `#D4A03C` | 212 160 60 | 0 25 72 17 | Uso restrito: selos e destaques de prazo |

### Neutros e semânticas

| Cor | HEX | Uso |
|---|---|---|
| Grafite | `#1C242E` | Texto corrido em fundo claro |
| Cinza | `#5A6875` | Texto de apoio, rótulos, metadados |
| Cinza Claro | `#C9D0D8` | Bordas neutras, estados desabilitados |
| Branco | `#FFFFFF` | Superfície base; texto sobre marinho |
| Sucesso | `#1E9E6A` | Mensagem entregue / atendimento concluído |
| Atenção | `#C98A0E` | Prazo próximo / fila em espera |
| Crítico | `#C0392F` | Falha de envio / prazo vencido |

### Contraste (WCAG 2.1)

| Combinação | Razão | Nível |
|---|---|---|
| Marinho Institucional sobre branco | 19,13:1 | AAA |
| Branco sobre Marinho Institucional | 19,13:1 | AAA |
| Turquesa Sinal sobre Marinho Institucional | 6,23:1 | AA |
| Turquesa Texto sobre branco | 5,22:1 | AA |
| Azul Ação sobre branco | 5,28:1 | AA |
| Turquesa Sinal sobre branco | 3,07:1 | apenas gráfico |

O Turquesa Sinal é suficiente para elementos gráficos e componentes de interface —
inclusive para o detalhe do "x" no logotipo, que é elemento gráfico e não texto —
porém insuficiente para texto corrido sobre branco. Nesse caso, usar o Turquesa Texto.

Os valores CMYK são conversão aritmética de referência. Para impressão, exigir prova
de cor e conversão em perfil ICC pelo fornecedor gráfico.

## Regras mínimas de aplicação

- **Área de proteção:** margem livre equivalente à altura da letra "L" em todos os lados.
- **Tamanho mínimo:** 24 px de altura em tela e 8 mm em impresso. Abaixo disso, usar o símbolo.
- **Fundos:** versão marinho sobre branco, Névoa ou Marinho 100; versão branca sobre
  Marinho Institucional, Marinho 900 ou imagem com escurecimento suficiente.
- **Não fazer:** alterar as cores das hastes do "x"; inclinar, distorcer ou condensar;
  aplicar contorno, sombra ou gradiente; recompor com fonte digitada; aplicar a versão
  marinho sobre fundo escuro; substituir o turquesa pelo verde característico do WhatsApp.

## Tipografia

Sora, peso 600, no logotipo — já convertida em curvas. Para textos de apoio, Sora nos
pesos 400 e 600. Licença SIL Open Font License 1.1; confirmar o texto da licença vigente
antes da distribuição do software.

## Pendências antes do uso definitivo

1. Busca de anterioridade no INPI para o sinal "LexAtende" nas classes de Nice pertinentes
   (software; serviços de tecnologia e de comunicação). Não realizada. O radical "Lex" é
   recorrente no mercado de tecnologia jurídica, o que eleva o risco de colidência.
2. Conferência das diretrizes de marca do WhatsApp e da política da API oficial em fonte
   atualizada do próprio fornecedor.
3. Verificação de disponibilidade de domínio e de perfis nas redes.
4. O tratamento de dados de atendimento atrai a LGPD (Lei nº 13.709/2018). A comunicação
   da marca não deve sugerir garantias de sigilo ou de segurança que o produto não assegure
   contratualmente.
