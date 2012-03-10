jQuery(function() {
  window.Chats = Backbone.Collection.extend();
  window.ChatApp = Backbone.View.extend({
    template: JST.chat_app,
    events: {
      'click .submit': 'publishMessage'
    },
    publishMessage: function(event){
      message = $(".message_val").val();
      client.publish('/foo', {text: message});
    },
    initialize: function(){
      _.bindAll(this, 'render', 'addOne');
      this.collection.bind('add', this.addOne);
    },
    render: function(){
      $(this.el).html(this.template());
      this.collection.each(this.addOne);
      return this.el;
    },
    addOne: function(model){
      var chat_item = new window.ChatItem({model:model});
      $(this.el).find("#messages").append(chat_item.render());
    }
  });
  window.ChatItem = Backbone.View.extend({
    initialize: function(){
      _.bindAll(this, 'render');
    },
    render: function(){
      $(this.el).html(this.model.get('name') + "<br />");
      return this.el;
    }
  });
  window.chats = new window.Chats();

  window.chat_app = new window.ChatApp({collection:window.chats});
  $("body").html(window.chat_app.render());
  var client = new Faye.Client('http://localhost:3000/faye');
  var subscription = client.subscribe('/foo', function(message) {
    window.chats.add([
      {name: message.text}
    ]);
  });
});
