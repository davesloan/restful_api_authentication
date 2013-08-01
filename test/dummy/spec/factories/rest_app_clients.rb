FactoryGirl.define do
  factory :rest_app_client, :class => RestAppClient do
    name Random.alphanumeric
    description Random.paragraphs(1)
    api_key "69704d90-4b77-012f-c334-68a86d3dfd02"
    secret "1e5483d9c6ddbe2f26eecf444ec7a976b2836ab17a209a0940f4dfdee1b3bc93"
    is_master true
  end
  factory :alternative_rest_app_client, :class => RestAppClient do
    name Random.alphanumeric
    description Random.paragraphs(1)
  end
  factory :rest_app_client_without_name, :class => RestAppClient do
    name nil
    description Random.paragraphs(1)
  end
  factory :rest_app_client_without_description, :class => RestAppClient do
    name Random.alphanumeric
  end
end
