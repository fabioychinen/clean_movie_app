# clean_movie_app

Aplicativo Flutter para exibição de catálogos de filmes e séries, consumindo a API do TMDB. Projeto estruturado com **Clean Architecture** e gerenciamento de estado utilizando **BLoC**. Inclui testes de API com **mocktail**.

---

## ✨ Funcionalidades

- Listagem de filmes e séries do catálogo TMDB  
- Exibição de rating para cada item  
- Visualização de sinopse ao clicar no cartaz  
- Arquitetura baseada em **Clean Architecture**  
- Gerenciamento de estado usando **BLoC**  
- Testes de integração e unidade com **mocktail**  
- Interface intuitiva e responsiva

---

## ⚙️ Tecnologias e Pacotes Utilizados

- [Flutter](https://flutter.dev/)
- [BLoC](https://bloclibrary.dev/)
- [Flutter Modular (opcional)](https://pub.dev/packages/flutter_modular)
- [Mocktail](https://pub.dev/packages/mocktail)
- [Dio/Http (para requisições HTTP)](https://pub.dev/packages/dio)
- [TMDB API](https://www.themoviedb.org/documentation/api)
- [Equatable](https://pub.dev/packages/equatable)

---

## 🚀 Como rodar o projeto

1. Clone o repositório  
    ```bash
    git clone https://github.com/seu-usuario/clean_movie_app.git
    cd clean_movie_app
    ```
2. Instale as dependências  
    ```bash
    flutter pub get
    ```
3. Adicione sua API Key do TMDB em um arquivo `.env` ou conforme orientação do código  
4. Rode o app  
    ```bash
    flutter run
    ```

---

## 🧪 Testes

Para rodar os testes (utilizando mocktail para simular APIs):

```bash
flutter test
