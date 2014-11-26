use Rack::Static, :root => 'angular', :urls => %w(/angular /views /model /js /css)

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('angular/index.html', File::RDONLY)
  ]
}