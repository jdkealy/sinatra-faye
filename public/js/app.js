jQuery(function() {
var client = new Faye.Client('http://localhost:3000/faye');
//var subscription = client.subscribe('/foo', function(message) {
//  // handle message
//});
client.publish('/foo', {text: 'Hi there'});
var subscription = client.subscribe('/foo', function(message) {
  $('body').append(message.text);
});
window.client = client;
});
