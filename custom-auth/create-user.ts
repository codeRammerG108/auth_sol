import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";
import { logger} from "./common.js";
 
let config = {
    userPoolID: process.env.USER_POOL_ID
};
 
function requireConfig<K extends keyof typeof config>(
    k: K
  ): NonNullable<(typeof config)[K]> {
    // eslint-disable-next-line security/detect-object-injection
    const value = config[k];
    if (value === undefined) {
        throw new Error(`Missing configuration for: ${k}`);
    }
    return value;
}
 
const CreateUserHandler = async(event: any, context: any, callback: any) => {
    try {
        //Logging Message
        console.log("Create User Lambda Function started.");
        logger.debug(JSON.stringify(event));
 
        //Getting User Email from Event
        const { email } = JSON.parse(event.body);
 
        //If no Email is found
        if (!email) {
            console.error("Error: Email is missing");
            return;
        }
 
        //If Email is Found - create parameters
        const CognitouserPoolID = requireConfig("userPoolID");
        const params = {
            UserPoolId: CognitouserPoolID,
            Username: email,
            TemporaryPassword: "Secure@1234$%", // Provide a temporary password for the user
            UserAttributes: [
              {
                Name: "email",
                Value: email,
              }
            ]
          };
          console.log("User getting created in cognito user pool.")
 
          //Getting AWS CognitoIdentity Service Provier to add User
          const cognitoIdentityServiceProvider = new CognitoIdentityProvider();
          const createUserResponse = await cognitoIdentityServiceProvider.adminCreateUser(params);
 
          //User Added
          console.log("User created successfully:", createUserResponse);
         
          const response = {
            statusCode: 200,
            body: JSON.stringify({ msg: "user created successfully" }),
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Credentials": true,
            },
          };
          callback(null, response);
    }catch(err) {
        console.error("Error creating user:", err);
        callback(null, {
            statusCode: 400,
            body: JSON.stringify({ err: err}),
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Credentials": true,
            },
          });
    }
}
 
export { CreateUserHandler as handler };