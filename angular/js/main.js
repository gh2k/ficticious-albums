var app = angular.module("json_gen", ['infinite-scroll', 'checklist-model']);

app.run(function($rootScope) {

  // clear all static page content, as it's for SEO/indexing purposes only
  document.body.innerHTML = '';

  var d = new Date();
  $rootScope.templateTime = d.getTime();

  $rootScope.templateUrl = function(url) {
    var d = new Date();
    return "/views/" + url + ".html?" + this.templateTime;
  };

  // replace the page content with our framework template
  var fw = document.createElement('ng-include');
  fw.setAttribute('src', "templateUrl('framework')");
  document.body.appendChild(fw);
});

/// Model for loading and storing our album data
app.controller('AlbumsController', function($scope, $http) {
  $scope.genres = [
    'World',
    'Soundtrack',
    'Folk',
    'Singer/Songwriter',
    'Rock',
    'Reggae',
    'Soul',
    'Funk',
    'Pop',
    'Latin',
    'K-Pop',
    'J-Pop',
    'Jazz',
    'Electronic',
    'Industrial',
    'Indie',
    'Alternative',
    'Hip-Hop',
    'Country',
    'Blues'];

  $scope.search = {
    'genre': ['Country']
  };

  $scope.albums = [];
  $scope.index_loaded = 0;
  $scope.loadMore = function() {
    for (var i = $scope.index_loaded; i < $scope.index_loaded + 10; i++) {
      $http.get('/model/' + $scope.manifest[i] + '.json')
           .then(function(res) {
              $scope.albums.push(res.data);
              $scope.triggerScroll();
            });
    }
    $scope.index_loaded += 10;
  };

  $scope.compare = function(actual, expected) {
    return expected.length == 0 || expected.indexOf(actual) > -1;
  };

  $scope.$watch('search', function() {
    $scope.triggerScroll();
  }, true);

  $http.get('/model/manifest.json')
       .then(function(res) {
          $scope.manifest = res.data;
          $scope.loadMore();
        },
        function(res) {
          $scope.error = "No manifest data. Looks like you've not yet generated the content.";
        });

  $scope.triggerScroll = function(){
    setTimeout(function(){
      $(window).scroll()
    },4)
  }
});