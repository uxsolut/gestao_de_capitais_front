# Dashboard Flutter App

Uma aplicação Flutter que replica exatamente o layout de dashboard fornecido, com tema escuro e efeitos de hover interativos.

## 🚀 Demonstração

**Aplicação funcionando:** https://8080-iyoilmj377mrsb0h6if2m-dd62a052.manusvm.computer

## ✨ Características

### Design Fiel ao Original
- **Tema escuro** com paleta de cores idêntica ao design fornecido
- **Layout responsivo** que se adapta a diferentes tamanhos de tela
- **Tipografia moderna** com hierarquia visual clara

### Componentes Implementados

#### 1. Header Interativo
- Saudação personalizada "Hello, Barbara! 👋"
- Ícones de notificação e configurações com **efeitos hover**
- Avatar do usuário com menu dropdown
- **Menus contextuais** para notificações, configurações e perfil

#### 2. Cards de Métricas
- **Sales**: $99,540 com indicador de crescimento (+5%)
- **Orders**: 45,000 com indicador de declínio (-2%)
- **Customers**: $60,450 com indicador de crescimento (+5%)
- **Animações de hover** com brilho e escala
- **Ícones temáticos** para cada métrica

#### 3. Gráfico de Barras Animado
- Título "Revenue" com ícone
- **Barras animadas** com gradiente azul
- **Efeitos de hover** nos elementos
- Labels dos meses (Jan-Jul)
- **Animação de entrada** suave

#### 4. Gráfico de Pizza Interativo
- Título "Sales by Category"
- **4 categorias** com cores distintas:
  - Electronics (35%) - Azul
  - Clothing (25%) - Laranja  
  - Books (20%) - Amarelo
  - Home & Garden (20%) - Verde
- **Hover interativo** nos segmentos e legenda
- **Percentuais dinâmicos** exibidos

#### 5. Cards de Estatísticas
- **98 orders** com ícone de carrinho
- **17 customers** com ícone de pessoas
- Design consistente com tema geral

#### 6. Lista de Pedidos
- **4 cards coloridos** com números: 12, 20, 57, 98
- **Indicadores "NEW"** em vermelho
- **Cores temáticas** para cada status

#### 7. Tabela de Dados
- **Colunas**: Description, Method, Amount, Date, Status, Profile
- **5 linhas de dados** de exemplo
- **Status coloridos**: Completed (verde), Pending (laranja), Failed (vermelho)
- **Hover effects** nas linhas

### Efeitos e Interatividade

#### Efeitos de Hover
- **Cards de métricas**: Escala, brilho e bordas coloridas
- **Gráfico de barras**: Sombras e destaque
- **Gráfico de pizza**: Segmentos expandem e destacam
- **Ícones do header**: Menus dropdown funcionais
- **Linhas da tabela**: Destaque visual

#### Animações
- **Fade-in** geral da aplicação
- **Animação de entrada** dos gráficos
- **Transições suaves** em todos os hovers
- **Efeitos de escala** nos cards

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.24.5** - Framework principal
- **Dart 3.5.4** - Linguagem de programação
- **Material Design** - Sistema de design
- **Custom Painters** - Para gráficos personalizados
- **Animations** - Para efeitos visuais

## 📁 Estrutura do Projeto

```
dashboard_app/
├── lib/
│   ├── main.dart              # Arquivo principal da aplicação
│   └── widgets/
│       ├── metric_card.dart   # Widget personalizado para cards de métricas
│       ├── bar_chart.dart     # Widget personalizado para gráfico de barras
│       └── pie_chart.dart     # Widget personalizado para gráfico de pizza
├── pubspec.yaml               # Dependências do projeto
└── README.md                  # Esta documentação
```

## 🎨 Paleta de Cores

- **Fundo principal**: #1a1a1a
- **Cards**: #2d2d2d
- **Azul**: #4285f4
- **Verde**: #34a853
- **Laranja**: #ff9800
- **Amarelo**: #ffc107
- **Vermelho**: #ea4335
- **Texto principal**: #ffffff
- **Texto secundário**: #b0b0b0

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK instalado
- Dart SDK instalado

### Comandos
```bash
# Navegar para o diretório do projeto
cd dashboard_app

# Instalar dependências
flutter pub get

# Executar em modo web
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0

# Ou executar em modo debug
flutter run
```

## 📱 Compatibilidade

- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Desktop** (Windows, macOS, Linux)
- ✅ **Mobile** (iOS, Android) - com adaptações responsivas

## 🎯 Funcionalidades Implementadas

### ✅ Concluído
- [x] Layout idêntico ao design fornecido
- [x] Tema escuro com cores exatas
- [x] Todos os componentes visuais
- [x] Efeitos de hover nos menus
- [x] Animações suaves
- [x] Gráficos interativos
- [x] Menus dropdown funcionais
- [x] Responsividade
- [x] Aplicação funcionando online

### 🔄 Melhorias Futuras Possíveis
- [ ] Integração com APIs reais
- [ ] Persistência de dados
- [ ] Mais opções de personalização
- [ ] Temas adicionais
- [ ] Exportação de relatórios

## 📞 Suporte

A aplicação foi desenvolvida seguindo exatamente o design fornecido, com atenção especial aos detalhes visuais e efeitos de interação solicitados.

**Link da aplicação funcionando:** https://8080-iyoilmj377mrsb0h6if2m-dd62a052.manusvm.computer

