import ballerina/jms;
import ballerina/log;

// Initialize a JMS connection with the provider.
jms:Connection jmsConnection = new({
    initialContextFactory: "com.sun.jndi.fscontext.RefFSContextFactory",
    providerUrl: "file:/jndidirectory/",
    connectionFactoryName: "QueueConnectionFactory",
    username: "",
    password:""
});

// Initialize a JMS session on top of the created connection.
jms:Session jmsSession = new(jmsConnection, {
    acknowledgementMode: "AUTO_ACKNOWLEDGE"
});
jms:QueueSender queueSender = new(jmsSession, queueName = "Queue");

public function main(string... args) {
    // Create a text message.
    var msg = jmsSession.createTextMessage("Hello from Ballerina");
    if (msg is error) {
        log:printError("Error occurred while creating message", err = msg);
    } else {
        var result = queueSender->send(msg);
        if (result is error) {
            log:printError("Error occurred while sending message", err = result);
        }
    }
}
