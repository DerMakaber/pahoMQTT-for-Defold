# PahoMQTT for Defold

The Paho MQTT Client for Defold
Originally written by Kévin KIN-FOO and available at
https://www.hivemq.com/blog/mqtt-client-library-encyclopedia-paho-lua/


## PahoMQTT functions


### mqtt.Utility.set_debug()
The following statement enables debug console logging for diagnosis.

    mqtt.Utility.set_debug(true)

### mqtt.client.create(hostname, port, callback)

Create an MQTT client that will be connected to the specified host.

**PARAMETERS**
* `hostname` (string) - Host name or address of the MQTT broker
* `port` (number) - Port number of the MQTT broker (default: 1883)
* `callback` (function) - Invoked when subscribed topic messages received

The _hostname_ must be provided, but both the _port_ and _callback function_
parameters are optional.  This function returns an MQTT client instance
that must be used for all subsequent MQTT operations for that server connection.

The _callback function_ is defined as follows ...

      function callback(topic, payload)
      -- application specific code
      end

**PARAMETERS**
* `topic` (string) - Topic for the received message
* `payload` (number) - Message data


#### MQTT.client.create(): Create an MQTT client instance

Create an MQTT client that will be connected to the specified host.

      mqtt_client = MQTT.client.create(hostname, port, callback)

The _hostname_ must be provided, but both the _port_ and _callback function_
parameters are optional.  This function returns an MQTT client instance
that must be used for all subsequent MQTT operations for that server connection.

      hostname string:   Host name or address of the MQTT broker
      port     integer:  Port number of the MQTT broker (default: 1883)
      callback function: Invoked when subscribed topic messages received

The _callback function_ is defined as follows ...

      function callback(topic, payload)
      -- application specific code
      end

      topic   -- string: Topic for the received message
      payload -- string: Message data

#### MQTT.client:destroy(): Destroy an MQTT client instance

When finished with a server connection, this statement cleans-up all resources
allocated by the client.

      mqtt_client:destroy()

#### MQTT.client:connect(): Make a connection to an MQTT server

Before messages can be transmitted, the MQTT client must connect to the server.

      mqtt_client:connect(identifier)

Each individual client connection must use a unique identifier.
Only the _identifier_ parameter is required, the remaining parameters
are optional.

      mqtt_client:connect(identifier, will_topic, will_qos, will_retain, will_message)

MQTT also provides a "last will and testament" for clients, which is a message
automatically sent by the server on behalf of the client, should the connection
fail.

      identifier   -- string: MQTT client identifier (maximum 23 characters)
      will_topic   -- string: Last will and testament topic
      will_qos     -- byte:   Last will and testament Quality Of Service
      will_retain  -- byte:   Last will and testament retention status
      will_message -- string: Last will and testament message

#### MQTT.client:disconnect(): Transmit MQTT Disconnect message

Transmit an MQTT disconnect message to the server.

      mqtt_client:disconnect()

#### MQTT.client:publish(): Transmit MQTT publish message

Transmit a message on a specified topic.

      mqtt_client:publish(topic, payload)

      topic   -- string: Topic for the published message
      payload -- string: Message data

#### MQTT.client:subscribe(): Transmit MQTT Subscribe message

Subscribe to one or more topics.  Whenever a message is published to one of
those topics, the callback function (defined above) will be invoked.

      mqtt_client:subscribe(topics)

      topics -- table of strings, e.g. { "topic1", "topic2" }

#### MQTT.client:handler(): Handle received messages, maintain keep-alive messages

The _handler()_ function must be called periodically to service incoming
messages and to ensure that keep-alive messages (PING) are being sent
when required.

The default _KEEP\_ALIVE\_TIME_ is 60 seconds, therefore _handler()_ must be
invoked more often than once per minute.

Should any messages be received on the subscribed topics, then _handler()_
will invoke the callback function (defined above).

      mqtt_client:handler()

#### MQTT.client:unsubscribe(): Transmit MQTT Unsubscribe message

Unsubscribe from one or more topics, so that messages published to those
topics are no longer received.

      topics -- table of strings, e.g. { "topic1", "topic2" }

---