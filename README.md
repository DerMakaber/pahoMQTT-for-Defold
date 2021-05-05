# PahoMQTT for Defold

The Paho MQTT Client for Defold.
Originally written by Kévin KIN-FOO and available at
https://www.hivemq.com/blog/mqtt-client-library-encyclopedia-paho-lua/

# Installation
You can use PahoMQTT in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

https://github.com/DerMakaber/pahoMQTT-for-Defold/archive/master.zip

Or point to the ZIP file of a [specific release](https://github.com/DerMakaber/pahoMQTT-for-Defold/releases).

# Usage

Connect to an MQTT broker (server).

      local mqtt = require "paho.mqtt"

      client = mqtt.client.create("broker.mqttdashboard.com", 1883, callback)
      self.client:connect("paho-defold-client-sample-identifier") -- Client identifier, must be unique

The _callback function_ will be called on a received message to a subcribed topic.

      local callback = function(topic, payload)
            print(string.format('Hey, %s just received: %s.', topic, payload))
      end

Subscribe to a topic.

	client:subscribe({"topic/sample"})

Unsubscribe from a topic

      client:unsubscribe({"topic/sample"})

Call the handler to service incoming transmission

      mqtt.client:handler()

Publish a message to a topic.

      client:publish("topic/sample", "Testmessage from Defold")

Disconnect the client.

      client:disconnect()

Destroy the client to free resources.

      client:destroy()

# Example

      local mqtt = require "paho.mqtt"

      BROKER = "broker.mqttdashboard.com"  -- Address of the Broker
      PORT = 1883 -- Port of the Broker
      CLIENT_ID = "paho-defold-client-sample-identifier" -- Client identifier, this must he unique

      -- Callback function that executes on a reveived message
      local callback = function(topic, payload)
            print(string.format('Hey, %s just received: %s.', topic, payload))
      end

      function init(self)
            -- Create a client
            self.client = mqtt.client.create(BROKER, PORT, callback)

            -- Connect with the client
            self.client:connect(CLIENT_ID)

            -- Subscribe to a topic
            self.topic = "topic/sample"
            self.client:subscribe({self.topic})
      end

      function final(self)
            -- Unsubscribe, disconnect and destroy on finalizing
            self.client:unsubscribe({self.topic})
            self.client:disconnect()
            self.client:destroy()
      end

      function update(self, dt)
            -- Check for received messages
            self.client:handler()
      end

      function on_input(self, action_id, action)
            if action_id == hash("touch") and action.pressed then
                  -- Publish to the Broker
                  self.client:publish(self.topic, "Testmessage from Defold")
            end
      end

## PahoMQTT functions

Load the Library with

      local mqtt = require "paho.mqtt"

### mqtt.Utility.set_debug()
The following statement enables debug console logging for diagnosis.

    mqtt.Utility.set_debug(true)

### mqtt.client.create(hostname, [port], [callback])

Create an MQTT client instance that will be connected to the specified host.
This MQTT client instance must be used for all subsequent MQTT operations for that server connection.

**PARAMETERS**
* `hostname` (string) - Host name or address of the MQTT broker
* `port` (number) - Port number of the MQTT broker (default: 1883)
* `callback` (function) - Invoked when subscribed topic messages received

The _callback function_ is defined as follows:

      function callback(topic, payload)
      -- application specific code
      end

**PARAMETERS**
* `topic` (string) - Topic for the received message
* `payload` (number) - Message data

### mqtt.client:connect(identifier, [will_topic], [will_qos], [will_retain], [will_message])

Make a connection to an MQTT broker.
Before messages can be transmitted, the MQTT client must connect to the broker.
Each individual client connection must use a unique identifier.

MQTT also provides a "last will and testament" for clients, which is a message automatically sent by the broker on behalf of the client, should the connection fail.

**PARAMETERS**
* `identifier` (string) - MQTT client identifier (maximum 23 characters)
* `will_topic` (string) - Last will and testament topic
* `will_qos` (byte) - Last will and testament Quality Of Service
* `will_retain` (byte) - Last will and testament retention status
* `will_message` (string) - Last will and testament message

### mqtt.client:disconnect()

Transmit an MQTT disconnect message to the broker.

### mqtt.client:auth(user, password)

Authenticate with the MQTT Broker.
Call this before connecting.

**PARAMETERS**
* `user` (string) - MQTT client identifier (maximum 23 characters)
* `password` (string) - Last will and testament topic

### mqtt.client:destroy()

When finished with a broker connection, this statement cleans-up all resources allocated by the client.

### mqtt.client:publish(topic, payload)

Transmit a message on a specified topic.

**PARAMETERS**
* `topic` (string) - Topic for the published message
* `payload` (string) - Message data

### mqtt.client:subscribe(topics)

Subscribe to one or more topics.  Whenever a message is published to one of those topics, the callback function (defined above) will be invoked.

**PARAMETERS**
* `topics` (table) - table of strings

      topics = { "topic1", "topic2" }

### mqtt.client:unsubscribe(topics)

Unsubscribe from one or more topics, so that messages published to those topics are no longer received.

**PARAMETERS**
* `topics` (table) - table of strings

### mqtt.client:handler()

This function must be called periodically to service incoming messages and to ensure that keep-alive messages (PING) are being sent when required.

The default _KEEP\_ALIVE\_TIME_ is 60 seconds, therefore _handler()_ must be invoked more often than once per minute.

Should any messages be received on the subscribed topics, then _handler()_ will invoke the callback function (defined above).

---