# Cars & Leads App - Flutter Clean Architecture + Auto Sync

## 📱 Sobre o Projeto

Este é um aplicativo Flutter desenvolvido seguindo os princípios de **Clean Architecture** e **SOLID**, utilizando **BLoC** para gerenciamento de estado. O app carrega dados de carros de uma API externa e permite que usuários demonstrem interesse em comprar um carro, salvando essas informações localmente.

## 🎯 Funcionalidades

- ✅ **Listagem de Carros**: Carrega dados da API [https://wswork.com.br/cars.json](https://wswork.com.br/cars.json)
- ✅ **Interface Intuitiva**: Cards com informações detalhadas dos carros
- ✅ **Botão "EU QUERO"**: Permite que usuários demonstrem interesse
- ✅ **Coleta de Dados do Usuário**: Formulário para nome, email e telefone
- ✅ **Armazenamento Local**: Salva leads no SQLite
- ✅ **Visualização de Interessados**: Lista todos os leads salvos
- ✅ **Offline First**: Cache local para funcionamento sem internet
- ✅ **Pull-to-Refresh**: Atualização por gesto nas páginas de leads
- ✅ **Auto-Sincronização Configurável**: Intervalos (1 / 5 / 15 min) para envio automático de leads pendentes
- ✅ **Heurística de Valor de Carro**: Ajusta valores abreviados (ex: 50 => 50.000) antes de formatar
- ✅ **Arquitetura Sliver nas listas**: Evita erros de viewport e melhora consistência de layout

## 🏗️ Arquitetura

### Clean Architecture + SOLID

O projeto segue a **Clean Architecture** proposta por Robert Martin, organizada em camadas:

```
lib/
├── core/                          # Núcleo da aplicação
│   ├── di/                        # Injeção de dependência
│   ├── database/                  # Configuração do banco de dados
│   ├── errors/                    # Tratamento de erros
│   ├── usecases/                  # Casos de uso base
│   └── widgets/                   # Widgets compartilhados
├── features/                      # Funcionalidades por feature
│   └── cars/                      # Feature de carros
│       ├── data/                  # Camada de dados
│       │   ├── datasources/       # Fontes de dados (API, Cache)
│       │   ├── models/            # Modelos de dados
│       │   └── repositories/      # Implementação dos repositórios
│       ├── domain/                # Camada de domínio
│       │   ├── entities/          # Entidades de negócio
│       │   ├── repositories/      # Contratos dos repositórios
│       │   └── usecases/          # Casos de uso
│       └── presentation/          # Camada de apresentação
│           ├── bloc/              # Gerenciamento de estado (BLoC)
│           ├── pages/             # Páginas da aplicação
│           └── widgets/           # Widgets específicos
│   └── leads/                     # Feature de lead
│       ├── data/                  # Camada de dados
│       │   ├── datasources/       # Fontes de dados (API, Cache)
│       │   ├── models/            # Modelos de dados
│       │   └── repositories/      # Implementação dos repositórios
│       ├── domain/                # Camada de domínio
│       │   ├── entities/          # Entidades de negócio
│       │   ├── repositories/      # Contratos dos repositórios
│       │   └── usecases/          # Casos de uso
│       └── presentation/          # Camada de apresentação
│           ├── bloc/              # Gerenciamento de estado (BLoC)
│           ├── pages/             # Páginas da aplicação
│           └── widgets/           # Widgets específicos
```

### Princípios SOLID Aplicados

1. **SRP (Single Responsibility Principle)**: Cada classe tem uma única responsabilidade
2. **OCP (Open/Closed Principle)**: Código aberto para extensão, fechado para modificação
3. **LSP (Liskov Substitution Principle)**: Subtipos substituíveis por seus tipos base
4. **ISP (Interface Segregation Principle)**: Interfaces pequenas e específicas
5. **DIP (Dependency Inversion Principle)**: Dependências abstratas, não concretas

## 🔧 Tecnologias e Dependências

### Dependências Principais
```yaml
dependencies:
  flutter_bloc: ^8.1.3          # Gerenciamento de estado
  equatable: ^2.0.5             # Comparação de objetos
  dio: ^5.3.2                   # Cliente HTTP
  sqflite: ^2.3.0               # Banco de dados SQLite
  get_it: ^7.6.4                # Injeção de dependência
  json_annotation: ^4.8.1       # Anotações JSON
  dartz: ^0.10.1                # Programação funcional
  intl: ^0.18.1                 # Formatação e internacionalização

dev_dependencies:
  build_runner: ^2.4.7          # Geração de código
  json_serializable: ^6.7.1     # Serialização JSON
  bloc_test: ^9.1.4             # Testes para BLoC
  mockito: ^5.4.2               # Mocks para testes
  sqflite_common_ffi: ^2.3.0    # SQLite para testes
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.9.0 ou superior
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS ou emulador

### Passos para Execução

1. **Clone o repositório**
```bash
git clone [https://github.com/BrunoDalI/teste_ws_work_flutter.git]
cd teste_ws_work_flutter
git checkout master
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Gere os arquivos necessários**
```bash
dart run build_runner build
```

4. **Execute o app**
```bash
flutter run
```

## 🧪 Testes

Conjunto atual focado em fluxos críticos de sincronização e estado:

| Arquivo | Objetivo |
|---------|----------|
| `test/features/lead/bloc/lead_bloc_test.dart` | Transições principais de `LeadBloc` (carregar / salvar) |
| `test/core/sync/auto_sync_service_test.dart` | Verifica envio periódico e marcação de leads como enviados |
| `test/features/lead/domain/lead_entity_test.dart` | Garante heurística de formatação de valor de carro |

Execução:
```powershell
flutter test
```

Cobertura (opcional):
```powershell
flutter test --coverage
```

Observação: Foram usados fakes ao invés de `mockito` para reduzir boilerplate e acelerar feedback.

## 📊 Estrutura de Dados

### Car Entity
```dart
class Car {
  final int id;
  final int timestampCadastro;
  final int modeloId;
  final int ano;
  final String combustivel;
  final int numPortas;
  final String cor;
  final String nomeModelo;
  final double valor;
}
```

### Lead Entity
```dart
class Lead {
  final int? id;
  final int carId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final DateTime createdAt;
  final String carModel;
  final double carValue;
}
```

## 🗄️ Banco de Dados

### Estrutura das Tabelas

#### Tabela Cars (Cache)
```sql
CREATE TABLE cars (
  id INTEGER PRIMARY KEY,
  timestampCadastro INTEGER NOT NULL,
  modeloId INTEGER NOT NULL,
  ano INTEGER NOT NULL,
  combustivel TEXT NOT NULL,
  numPortas INTEGER NOT NULL,
  cor TEXT NOT NULL,
  nomeModelo TEXT NOT NULL,
  valor REAL NOT NULL
);
```

#### Tabela Leads
```sql
CREATE TABLE leads (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  carId INTEGER NOT NULL,
  userName TEXT NOT NULL,
  userEmail TEXT NOT NULL,
  userPhone TEXT NOT NULL,
  createdAt INTEGER NOT NULL,
  carModel TEXT NOT NULL,
  carValue REAL NOT NULL
);
```

## 🔄 Fluxo de Dados

### Carregamento de Carros
1. **UI** solicita carros via BLoC
2. **BLoC** chama UseCase GetCars
3. **UseCase** chama Repository
4. **Repository** tenta buscar dados remotos
5. Se sucesso: salva no cache e retorna dados
6. Se falha: retorna dados do cache (se disponível)
7. **BLoC** emite estado com dados ou erro
8. **UI** atualiza interface

### Salvamento de Lead
1. **UI** coleta dados do usuário
2. **BLoC** recebe evento SaveLead
3. **BLoC** chama UseCase SaveLead
4. **UseCase** chama Repository
5. **Repository** salva no SQLite
6. **BLoC** emite estado de sucesso ou erro
7. **UI** mostra feedback

## 📱 Interfaces

### Tela Principal (CarPage)
- Lista de carros em cards
- Pull-to-refresh
- Loading states
- Error handling
- Navegação para tela de leads

### Tela de Leads (LeadsPage)
- Lista de interessados
- Informações do cliente
- Dados do carro de interesse
- Estados vazios

### Dialog de Dados (UserInfoDialog)
- Formulário validado
- Campos: nome, email, telefone
- Validações em tempo real

### Auto-Sincronização de Leads
1. UI ativa auto-sync selecionando intervalo.
2. `AutoSyncService.enable(interval)` inicia `Timer.periodic`.
3. A cada tick: busca leads `isSent=false` -> envia em lote -> marca como enviados -> emite `AutoSyncResult`.
4. Página / BLoC escuta stream e dispara `LoadLeadsEvent` para refletir novos estados.
5. Desativação via `disable()` cancela timer e limpa previsão de próxima execução.

Métricas básicas (expostas internamente): próxima execução (`nextRunAt`), intervalo e stream de resultados.

## 🎨 Design Patterns Utilizados

1. **Repository Pattern**: Abstração da camada de dados
2. **UseCase Pattern**: Encapsulamento da lógica de negócio
3. **BLoC Pattern**: Gerenciamento de estado reativo
4. **Dependency Injection**: Inversão de controle
5. **Factory Pattern**: Criação de objetos
6. **Observer Pattern**: Comunicação via streams

## 🤔 Por que BLoC, SOLID, Clean Architecture e Dio?

### BLoC
- Separação clara de UI e lógica de negócio via eventos/estados.
- Facilita testes unitários isolando side-effects.
- Escalável: múltiplos fluxos de estado podem coexistir sem acoplamento direto aos widgets.

### Clean Architecture
- Protege regras de negócio de detalhes de implementação (HTTP, banco, UI).
- Permite substituição de camadas (ex: trocar Dio por outro cliente) sem tocar domínio.
- Estrutura previsível reduz curva de aprendizado para novos contribuidores.

### Princípios SOLID
- SRP: cada classe com responsabilidade única (ex: UseCases finos, Repositórios abstratos).
- OCP: novos fluxos (ex: auto sync) adicionados sem modificar casos de uso existentes.
- LSP: abstrações (repositories, usecases) podem ser trocadas por fakes/mocks em testes.
- ISP: interfaces enxutas (LeadRepository/CarRepository) evitam dependências desnecessárias.
- DIP: Domínio depende de abstrações; infraestrutura injeta implementações concretas via DI (`get_it`).

### Dio
- Recursos avançados (interceptors, cancel tokens, timeout configurável) prontos para produção.
- Facilidade para adicionar logging e retry estrategicamente.
- Melhor controle de resposta/erros comparado ao `http` simples, com suporte robusto a FormData e Streams.

### Benefício Combinado
Juntos, BLoC + Clean Architecture + SOLID + Dio entregam:
- Manutenção facilitada
- Alto nível de testabilidade
- Evolução incremental sem refatorações amplas
- Clareza de fluxo (UI -> Evento -> BLoC -> UseCase -> Repository -> DataSource)


### Adicional
Aqui estou montando um guia para compartilhar conhecimento onde explico tudo com exemplos: 
https://brunodali.github.io/flutter_guide_webpage/

## �️ Monitoramento e Qualidade (Flutter DevTools)
Uso sistemático do DevTools para garantir estabilidade, performance e saúde do app:

### Analyze (Análise Estática)
- Comando periódico: `flutter analyze`.
- Objetivo: detectar imports não usados, padrões incorretos e problemas antes do runtime.
- Resultado: código mais consistente e menor risco de regressões silenciosas.

### Performance
- Aba Performance para observar timeline de frames e detectar jank.
- Otimizações aplicadas: remoção de rebuilds desnecessários (ex: consolidando scroll em `CustomScrollView`).
- Validação de animação suave na Splash (entrada do ícone de carro sem quedas de frame).

### Memory
- Monitoramento de heap durante navegação CarPage -> LeadsPage -> LeadSyncPage.
- Conferência de descarte de controllers (AnimationController / timers em bloc/services).
- Resultado: ausência de crescimento contínuo (indicador de não haver leak evidente).

### Widget Inspector
- Uso para inspecionar árvore e constraints ao resolver erro de viewport (scroll aninhado).
- Benefício: diagnosticou rapidamente necessidade de unificar estrutura em Slivers.

### Network
- Observação de chamadas Dio (latência e payload) para confirmar cache vs remoto.
- Verificação de status codes e tempo médio de resposta.

### Logging / Console
- Logs de estados de BLoC (transições) usados para validar fluxo de sincronização automática.
- Simplificação: preferido logs pontuais ao invés de verbose global para manter clareza.

### Timeline
- Inspeção de eventos em sequência durante sincronização em lote para garantir que UI não bloqueia.
- Uso complementar à aba Performance para correlacionar picos de CPU com envio de leads.

### Resumo Geral
- Conjunto de ferramentas aplicado de forma incremental (durante implementação / refino / testes).
- Foco em detectar cedo: layout quebrado, jank, consumo de memória e gargalos de rede.
- Resultado: app consistente, responsivo e com ciclo de feedback rápido.

## �🔍 Tratamento de Erros

### Tipos de Erro
- **ServerException**: Erros de servidor/API
- **NetworkException**: Problemas de rede
- **CacheException**: Problemas de cache/banco local
- **ValidationException**: Erros de validação

### Estratégia de Fallback
- Tenta dados remotos primeiro
- Em caso de falha, usa cache local
- Mostra mensagens específicas para cada erro

## 📈 Melhores Práticas Implementadas

### Código
- ✅ Clean Architecture
- ✅ Princípios SOLID
- ✅ Dependency Injection
- ✅ Error Handling robusto
- ✅ Código testável
- ✅ Documentação inline

### Performance
- ✅ Lazy loading de dependências
- ✅ Cache inteligente
- ✅ Otimização de builds
- ✅ Memory management

### UX/UI
- ✅ Loading states
- ✅ Empty states
- ✅ Error states
- ✅ Pull-to-refresh
- ✅ Feedback visual
- ✅ Validação de formulários

## 🔧 Configurações de Desenvolvimento

### Android
```kotlin
minSdkVersion 21
targetSdkVersion 34
```

### iOS
```
iOS 12.0+
```

### Linting
O projeto usa `flutter_lints` para manter qualidade do código:
```yaml
include: package:flutter_lints/flutter.yaml
```

---

**Tecnologias**: Flutter • Dart • SQLite • Clean Architecture • BLoC • SOLID • TDD