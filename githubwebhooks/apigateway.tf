resource "aws_api_gateway_account" "account" {
}

resource "aws_api_gateway_rest_api" "webhooks" {
    name = "GitHub-WebHook"
    description = "Receives GitHub web hook notifications"
}

resource "aws_api_gateway_resource" "webhook" {
    rest_api_id = "${aws_api_gateway_rest_api.webhooks.id}"
    parent_id = "${aws_api_gateway_rest_api.webhooks.root_resource_id}"
    path_part = "webhook"
}

resource "aws_api_gateway_method" "webhook_post" {
    rest_api_id = "${aws_api_gateway_rest_api.webhooks.id}"
    resource_id = "${aws_api_gateway_resource.webhook.id}"
    http_method = "POST"
    authorization = "NONE"
    request_parameters = {
        "method.request.header.X-GitHub-Delivery" = true
        "method.request.header.X-GitHub-Event" = true
    }
}

resource "aws_api_gateway_integration" "webhook_post_lambda" {
    rest_api_id = "${aws_api_gateway_rest_api.webhooks.id}"
    resource_id = "${aws_api_gateway_resource.webhook.id}"
    http_method = "${aws_api_gateway_method.webhook_post.http_method}"
    type = "AWS"
    uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda_receive.arn}/invocations"
    integration_http_method = "POST"
    passthrough_behavior = "WHEN_NO_TEMPLATES"
    request_templates = {
        "application/json" = <<EOF
##  See http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
##  This template will pass through all parameters including path, querystring, header, stage variables, and context through to the integration endpoint via the body/payload
#set($allParams = $input.params())
{
"body-json" : $input.json('$'),
"params" : {
#foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
"$type" : {
    #foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
        #if($foreach.hasNext),#end
    #end
}
    #if($foreach.hasNext),#end
#end
},
"stage-variables" : {
#foreach($key in $stageVariables.keySet())
"$key" : "$util.escapeJavaScript($stageVariables.get($key))"
    #if($foreach.hasNext),#end
#end
},
"context" : {
    "account-id" : "$context.identity.accountId",
    "api-id" : "$context.apiId",
    "api-key" : "$context.identity.apiKey",
    "authorizer-principal-id" : "$context.authorizer.principalId",
    "caller" : "$context.identity.caller",
    "cognito-authentication-provider" : "$context.identity.cognitoAuthenticationProvider",
    "cognito-authentication-type" : "$context.identity.cognitoAuthenticationType",
    "cognito-identity-id" : "$context.identity.cognitoIdentityId",
    "cognito-identity-pool-id" : "$context.identity.cognitoIdentityPoolId",
    "http-method" : "$context.httpMethod",
    "stage" : "$context.stage",
    "source-ip" : "$context.identity.sourceIp",
    "user" : "$context.identity.user",
    "user-agent" : "$context.identity.userAgent",
    "user-arn" : "$context.identity.userArn",
    "request-id" : "$context.requestId",
    "resource-id" : "$context.resourceId",
    "resource-path" : "$context.resourcePath"
    }
}
EOF
    }
}

resource "aws_api_gateway_method_response" "200" {
    rest_api_id = "${aws_api_gateway_rest_api.webhooks.id}"
    resource_id = "${aws_api_gateway_resource.webhook.id}"
    http_method = "${aws_api_gateway_method.webhook_post.http_method}"
    status_code = "200"
    response_models {
        "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "response" {
    rest_api_id = "${aws_api_gateway_rest_api.webhooks.id}"
    resource_id = "${aws_api_gateway_resource.webhook.id}"
    http_method = "${aws_api_gateway_method.webhook_post.http_method}"
    status_code = "${aws_api_gateway_method_response.200.status_code}"
}

resource "aws_api_gateway_deployment" "webhook_prod_deployment" {
    depends_on = [
        "aws_api_gateway_method.webhook_post"
    ]

    rest_api_id = "${aws_api_gateway_rest_api.webhooks.id}"
    stage_name = "prod"
    description = "Production instance of GitHub web hooks ingestion"
}
