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
  $scope.albums = [];
  $scope.index_loaded = 0;
  $scope.loadMore = function() {
    for (var i = $scope.index_loaded; i < $scope.index_loaded + 10; i++) {
      $http.get('/model/' + $scope.manifest[i] + '.json')
           .then(function(res) {
              $scope.albums.push(res.data);
            });
    }
    $scope.index_loaded += 10;
  };

  $http.get('/model/manifest.json')
       .then(function(res) {
          $scope.manifest = res.data;
          $scope.loadMore();
        },
        function(res) {
          $scope.error = "No manifest data. Looks like you've not yet generated the content.";
        });
});
