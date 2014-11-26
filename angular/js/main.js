var app = angular.module("json_gen", []);

app.run(function($rootScope) {
    // clear all static page content, as it's for SEO/indexing purposes only
    document.body.innerHTML = '';

    // replace the page content with our framework template
    fw = document.createElement('ng-include');
    fw.setAttribute('src', "'/views/framework.html'");
    document.body.appendChild(fw);
});

/// Model for loading and storing our album data
app.controller('AlbumsController', function($scope, $http) {
  $http.get('/model/manifest.json')
       .then(function(res) {
          $scope.manifest = res.data;
        },
        function(res) {
          $scope.error = "No manifest data. Looks like you've not yet generated the content.";
        });
});