module OmniAuth
  module Strategies
    class AuthTransis < OmniAuth::Strategies::OAuth2
      option :name, :auth_transis

      uid do
        raw_info["id"]
      end

      info do
        {
          :email         => raw_info["email"],
          :organizations => raw_info['organizations'],
          :features      => raw_info['features'],
          :current_organization_id => raw_info['current_organization_id'],
          :raw_info      => raw_info
        }
      end

      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params).merge(request.params))
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
    end

    class AuthTransisDeveloper
      include OmniAuth::Strategy
      option :name, :auth_transis_developer

      option :fields, [:email]
      option :uid_field, :email

      def request_phase
        form = OmniAuth::Form.new(:title => "Auth-Transis Developer Login", :url => callback_path, :header_info => <<-HTML)
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
  <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"></script>

  <link href="http://wwwendt.de/tech/dynatree/src/skin/ui.dynatree.css" rel="stylesheet" type="text/css">
  <script src="http://wwwendt.de/tech/dynatree/src/jquery.dynatree.js" type="text/javascript"></script>
<script type="text/javascript">
  var updateRawInfoJsonFromTree = function(tree){
    var rawInfo = {organizations: [], features: []};
    organizationNames = [];
    $.each(tree.getSelectedNodes(), function(index, node){
      if(node.data.key.organization_name && organizationNames.indexOf(node.data.key.organization_name) == -1){
        organizationNames.push(node.data.key.organization_name);
      }
      if(node.data.key.feature_name){
        rawInfo.features.push({organization_id: organizationNames.indexOf(node.data.key.organization_name)+1, name: node.data.key.feature_name});
      }
    });
    $.each(organizationNames, function(index, name){
      rawInfo.organizations.push({id: index+1, name: name});
    });
    $('#raw_info_json')[0].value = JSON.stringify(rawInfo);
  }
  $(function(){
    var feature = function(organization_name, feature_name, selected){
      return {title: feature_name, key: {organization_name: organization_name, feature_name: feature_name}, select: selected};
    }
    var organization = function(name, selected){
      return {title: name, expand: true, key: name, children: [
          feature(name,'admin',selected),
          feature(name,'media_plan_creation',selected),
          feature(name,'media_plan_negotiation',selected),
          feature(name,'media_plan_analysis',selected),
          feature(name,'finance',selected)
        ]
      }
    }
    var organizations = [
      organization('Centro',true),
      organization('TransisTestAgency',false),
      organization('TransisTestPublisher',false),
    ];
    $("#raw_info").dynatree({
      checkbox: true,
      selectMode: 3,
      children: organizations,
      onSelect: function(select, node) {
        updateRawInfoJsonFromTree(node.tree);
      },
      onDblClick: function(node, event) {
        node.toggleSelect();
      },
      onKeydown: function(node, event) {
        if( event.which == 32 ) {
          node.toggleSelect();
          return false;
        }
      },
    });
    updateRawInfoJsonFromTree($('#raw_info').dynatree('getRoot').tree);
  });
</script>
        HTML
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.gsub("_", " "), field.to_s
        end
        form.html "<input type='hidden' id='raw_info_json' name='raw_info_json' />"
        form.html "<h3>Features</h3>"
        form.html "<div id='raw_info'></div>"
        form.button "Sign In"
        form.to_response
      end

      uid do
        request.params[options.uid_field.to_s]
      end

      info do
        options.fields.inject({}) do |hash, field|
          hash[field] = request.params[field.to_s]
          hash
        end.merge(
          :organizations => raw_info['organizations'],
          :features      => raw_info['features']
        )
      end

      def raw_info
        @raw_info ||= JSON.parse(request.params['raw_info_json'])
      end
    end
  end
end
