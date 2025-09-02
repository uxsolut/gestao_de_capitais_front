# TODO - Correção Sistema de Autenticação JWT

## Problemas Identificados:
1. ❌ LoginController não é atualizado quando login é feito na LoginPage
2. ❌ Token JWT não é enviado nas requisições HTTP
3. ❌ Nome do usuário não aparece (mostra "Usuário" em vez do nome real)
4. ❌ Requisições de carteiras falham por falta de autenticação

## Correções Realizadas:

### Fase 1: Correção do LoginController ✅
- [x] Modificar LoginPage para usar LoginController
- [x] Salvar dados do usuário no LoginController após login
- [x] Persistir dados do usuário no storage
- [x] Inicializar LoginController no main.dart

### Fase 2: Correção das Requisições HTTP ✅
- [x] Criar HttpService com interceptor JWT automático
- [x] Modificar CarteiraService para usar HttpService
- [x] Modificar RoboService para usar HttpService
- [x] Modificar OrdemService para usar HttpService
- [x] Atualizar DashboardPage para usar novos services

### Fase 3: Correção da Exibição do Nome ✅
- [x] LoginController agora salva dados do usuário corretamente
- [x] Dashboard deve ler nome do usuário do LoginController

### Fase 4: Teste Completo
- [ ] Testar login e persistência
- [ ] Testar requisições autenticadas
- [ ] Verificar exibição do nome do usuário

