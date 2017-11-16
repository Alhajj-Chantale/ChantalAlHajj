Assumptions

- familiarity with OOP, java, maven, and jee
- java application server listening on localhost:8080

Prerequisites

- Google API access credentials (Client ID, Client Secret). Set it up here https://code.google.com/apis/console/
- Set up allowed Redirect URIs at Google API -> API Access. Input: https://localhost:8443/SMB215-OAuth-Google/index.jsp

Usage

1. Add Client ID, and Client Secret parameters to GoogleAuthHelper.java
2. Compile the project ($ mvn clean install)
3. Deploy war to application server
4. Browse to: https://localhost:8443/SMB215-OAuth-Google/
5. Click "log in with google" on top of this page