import ballerina/jms;
import ballerina/log;

// Initialize a JMS connection with the provider.
jms:Connection jmsConnection = new({
    initialContextFactory: "com.sun.jndi.fscontext.RefFSContextFactory",
    providerUrl: "file:/jndidirectory/",
    connectionFactoryName: "QueueConnectionFactory",
    username: "",
    password: ""
});

// Initialize a JMS session on top of the created connection.
jms:Session jmsSession = new(jmsConnection, {
        acknowledgementMode: "AUTO_ACKNOWLEDGE"
    });

// Initialize a queue receiver using the created session.
listener jms:QueueReceiver queueReceiver = new(jmsSession, queueName = "Queue");

public function main() {
    jms:QueueReceiverCaller caller = queueReceiver.getCallerActions();
    var result = caller->receive(timeoutInMilliSeconds = 5000);

    if (result is jms:Message) {
        var messageText = result.getTextMessageContent();
        if (messageText is string) {
            log:printInfo("Message : " + messageText);
        } else {
            log:printError("Error occurred while reading message.",
                err = messageText);
        }
    } else if (result is ()) {

        log:printInfo("Message not received");

    } else {
        log:printInfo("Error receiving message : " +
                <string>result.detail().message);
    }
}
