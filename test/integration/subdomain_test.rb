class SubDomainTest < ActionDispatch::IntegrationTest
  fixtures :all

  test 'bad subdomain' do
    host! 'idonotexist.test.host'
    assert_recognizes({ controller: 'subdomains', action: 'show' }, 'http://idontexist.test.host')
    get '/'
    assert_response :not_found
  end

  test 'amsterdam subdomain' do
    host! 'amsterdam.test.host'
    assert_recognizes({ controller: 'subdomains', action: 'show' }, 'http://amsterdam.test.host')
    get '/'
    assert_response :redirect
    assert_redirected_to 'http://test.host/petitions/desks/amsterdam'
  end

  test 'petition subdomain domain' do
    host! 'testsubdomain.test.host'
    assert_recognizes({ controller: 'petitions', action: 'show' }, 'http://testsubdomain.test.host')
    get '/'
    assert_response :success
    # Allow translations for subdomain
    get '/?locale=en'
    assert_response :success
  end
end
