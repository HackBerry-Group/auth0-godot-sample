# Auth0 Godot Sample

This is a sample project that creates a simple login page and works with the
Auth0 "Resource Owner Password" grant type. It's not the recommended way to do
authentication with Auth0, but to do that, you would need a web page viewer
within the engine. Alternatively, a device code flow could also work (user
navigates to a page in their browser and retrieves a one-time use code that is
typed into the engine, as is common for Roku and similar devices).

To use this, you will need to:

1. create an Auth0 Application and API
2. enable the "Password" grant type under the Application "Advanced Settings"
3. add a scope to the API
4. create a user under the User Management page
5. grant the user the permission for the scope you created
6. under the main account settings, set the default directory to "Username-Password-Authentication"

Finally, override the `const` values in `AuthSingleton.gd`.

* `AUTH0_DOMAIN` is the domain of the Application, such as `my-app.us.auth0.com`
* `AUDIENCE` is the identifier of the API
* `SCOPE` is the scope you added earlier
* `CLIENT_ID` is found in the Application settings

Note: you do not need the client secret if your application has "Token Endpoint
Authentication Method" set to "None."
