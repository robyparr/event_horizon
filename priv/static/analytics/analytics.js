(function() {
  var projectKey = document.querySelector('meta[name="event-horizon-project-key"]').content;

  window.eh = function eh(action, data) {
    var data = data || {};

    if (projectKey !== '') {
      var xhr = new XMLHttpRequest();
      xhr.open('POST', 'https://event-horizon.robyparr.com/api/events', true);
      xhr.setRequestHeader('Content-type', 'application/json; charset=UTF-8');
      xhr.setRequestHeader('Authorization', 'Bearer ' + projectKey);

      xhr.send(JSON.stringify({
        event: {
          action: action,
          resource: data.resource,
          resource_type: data.resourceType,
          count: data.count || 1
        }
      }));
    }
  }

  eh('pageview')
})()
