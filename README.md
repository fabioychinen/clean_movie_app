# clean_movie_app

Aplicativo Flutter para exibição de catálogos de filmes e séries, consumindo a API do TMDB. Projeto estruturado com **Clean Architecture** e gerenciamento de estado utilizando **BLoC**. Inclui testes de API com **mocktail**.

---

## Funcionalidades

- Listagem de filmes e séries do catálogo TMDB  
- Exibição de rating para cada item  
- Visualização de sinopse ao clicar no cartaz  
- Arquitetura baseada em **Clean Architecture**  
- Gerenciamento de estado usando **BLoC**  
- Testes de integração e unidade com **mocktail**  
- Interface intuitiva e responsiva

---

## Tecnologias e Pacotes Utilizados

- [Flutter](https://flutter.dev/)
- [BLoC](https://bloclibrary.dev/)
- [Flutter Modular (opcional)](https://pub.dev/packages/flutter_modular)
- [Mocktail](https://pub.dev/packages/mocktail)
- [Dio/Http (para requisições HTTP)](https://pub.dev/packages/dio)
- [TMDB API](https://www.themoviedb.org/documentation/api)
- [Equatable](https://pub.dev/packages/equatable)

---

## Como rodar o projeto

1. Clone o repositório  
    ```bash
    git clone https://github.com/seu-usuario/clean_movie_app.git
    cd clean_movie_app
    ```
2. Instale as dependências  
    ```bash
    flutter pub get
    ```
3. Crie o `env.json` a partir do modelo e preencha seu **token de leitura da API** da TMDB (em *Configurações → API → API Read Access Token*; o arquivo é ignorado pelo git)  
    ```bash
    cp env.example.json env.json
    ```
4. Rode o app passando a configuração  
    ```bash
    flutter run --dart-define-from-file=env.json
    ```
    No VS Code, as configurações de `.vscode/launch.json` já passam esse argumento. Sem a chave, o app falha logo na inicialização com uma mensagem explicando o que falta.

---

## Testes

Para rodar os testes (utilizando mocktail para simular APIs):

```bash
flutter test
