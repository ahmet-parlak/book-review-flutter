## About Project

This repository contains the code for a mobile application developed using Flutter. The application serves as a companion to [this Laravel project](https://github.com/ahmet-parlak/book-review) , as it relies on the web project's API for data retrieval and authentication. It serves as a client-side interface, allowing users to interact with the web application's API and access its features on their mobile devices.

The mobile application provides a convenient way for users to engage with the book rating and review platform, discover new books, and manage their book lists. Please note that the mobile application relies on the web application's API for data retrieval and authentication. Therefore, it cannot function independently and requires a working connection to the web application.

## Features
- **User Authentication:** Users can log in to the mobile application using their credentials, which are authenticated through the web project's API. This ensures that only registered users can access the app's features.
- **Book Search:** The mobile app includes a search functionality that allows users to find specific books by title, author, or ISBN. The search queries are sent to the web project's API, which retrieves relevant results from the book database.
- **Book Rating and Review:** Users can rate books on a scale and provide detailed reviews directly from the mobile app. The ratings and reviews are submitted to the web project's API, which updates the corresponding data in the book rating and review system.
- **Personal Book Lists:** Users have the ability to access and manage their personal book lists from the mobile application. The lists are synchronized with the web project's API, allowing users to view and modify their lists across both platforms.
- **Public and Private Lists:** Users can choose whether to make their book lists public or private directly from the mobile app. Public lists are visible to other users of the web project, while private lists remain visible only to the creator.
- **Error/Incomplete Book Reporting:** Users can report books that contain errors or incomplete information directly from the mobile app. This functionality sends a report to the web project's API, notifying the system administrators about any issues encountered with book details.
- **Book Request Form:** Users can submit requests for adding missing books to the system from the mobile application. These requests are sent to the web project's API for review and processing by the administrators.
- **Integration with Web Project's API:** The mobile app integrates with the web project's API to fetch data, perform authentication, and update the relevant information in the book rating and review system.

## Technologies
- **Flutter Framework:** The mobile application is developed using the Flutter framework, which allows for cross-platform development of high-quality mobile apps for both iOS and Android.
- **API Integration:** The mobile app utilizes HTTP requests to communicate with the web project's API, which is developed using the Laravel framework.
- **State Management:** Flutter provides various state management solutions, such as Provider, Riverpod, or MobX, to manage the app's state and ensure data consistency.
- **UI Design:** The mobile app's user interface is designed using Flutter's built-in widgets and customizable components. The design can be further enhanced with additional packages, such as Material Design or Cupertino widgets, to provide a native-like experience for both iOS and Android platforms.
- **Additional Packages:** The mobile application utilizes additional Flutter packages for UI components, HTTP requests, state management, and other necessary functionality. Some of these packages include:
  - **Dio:** Dio is a powerful HTTP client for Dart that simplifies the process of making HTTP requests and handling responses.
  - **Provider:** Provider is a state management solution for Flutter that allows efficient and easy management of application state.
  - **Flutter Secure Storage:** Flutter Secure Storage provides a secure way to store sensitive data such as authentication tokens, API keys, or other private information on the device.

Please note that the mobile application requires an active internet connection and relies on the availability of the web project's API to function properly.

## Preview

<div align="center">
<img src="project.gif" width="auto" width="300" height="300">
</div>
