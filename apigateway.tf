resource "aws_api_gateway_rest_api" "MotrWeb" {
  name               = "motr-web-${var.environment}"
  description        = "MOTR Web for ${var.environment}"
  binary_media_types = "${var.binary_media_types}"
}

####################################################################################################################################
# API GATEWAY ROOT RESOURCE

# GET method -> ROOT (/)
resource "aws_api_gateway_method" "LambdaRootGET" {
  rest_api_id      = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id      = "${aws_api_gateway_rest_api.MotrWeb.root_resource_id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = "${var.with_cloudfront ? true : false}"
}

# integration between ROOT resource's GET method and Lambda function (back-end)
resource "aws_api_gateway_integration" "LambdaRootGET" {
  rest_api_id             = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id             = "${aws_api_gateway_rest_api.MotrWeb.root_resource_id}"
  http_method             = "${aws_api_gateway_method.LambdaRootGET.http_method}"
  type                    = "AWS_PROXY" 
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.MotrWebHandler.arn}:${aws_lambda_alias.MotrWebHandlerAlias.name}/invocations"
  integration_http_method = "POST"
  #credentials             = "${aws_iam_role.Lambda.arn}"
}

resource "aws_api_gateway_method_response" "LambdaRootGET_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_rest_api.MotrWeb.root_resource_id}"
  http_method         = "${aws_api_gateway_method.LambdaRootGET.http_method}"
  status_code         = "200"
  response_models     = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Date"           = true
    "method.response.header.ETag"           = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
    "method.response.header.Last-Modified"  = true
  }
}

resource "aws_api_gateway_integration_response" "LambdaRootGET_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_rest_api.MotrWeb.root_resource_id}"
  http_method         = "${aws_api_gateway_method.LambdaRootGET.http_method}"
  status_code         = "${aws_api_gateway_method_response.LambdaRootGET_200.status_code}"
  response_parameters = {
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
    "method.response.header.Date"           = "integration.response.header.Date"
    "method.response.header.ETag"           = "integration.response.header.ETag"
    "method.response.header.Last-Modified"  = "integration.response.header.Last-Modified"
  }
  depends_on          = ["aws_api_gateway_integration.LambdaRootGET"]
}

####################################################################################################################################
# API GATEWAY LAMBDA WILDCARD RESOURCE

resource "aws_api_gateway_resource" "LambdaWildcard" {
  rest_api_id = "${aws_api_gateway_rest_api.MotrWeb.id}"
  parent_id = "${aws_api_gateway_rest_api.MotrWeb.root_resource_id}"
  path_part = "{proxy+}"
}

# GET method -> Lambda Wildcard/{proxy}
resource "aws_api_gateway_method" "LambdaWildcardGET" {
  rest_api_id      = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id      = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = "${var.with_cloudfront ? true : false}"
}

# integration between Lambda Wildcard resource's GET method and Lambda function (back-end)
resource "aws_api_gateway_integration" "LambdaWildcardGET" {
  rest_api_id             = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id             = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method             = "${aws_api_gateway_method.LambdaWildcardGET.http_method}"
  type                    = "AWS_PROXY" 
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.MotrWebHandler.arn}:${aws_lambda_alias.MotrWebHandlerAlias.name}/invocations"
  integration_http_method = "POST"
  #credentials             = "${aws_iam_role.Lambda.arn}"
}

resource "aws_api_gateway_method_response" "LambdaWildcardGET_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method         = "${aws_api_gateway_method.LambdaWildcardGET.http_method}"
  status_code         = "200"
  response_models     = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Date"           = true
    "method.response.header.ETag"           = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
    "method.response.header.Last-Modified"  = true
  }
}

resource "aws_api_gateway_integration_response" "LambdaWildcardGET_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method         = "${aws_api_gateway_method.LambdaWildcardGET.http_method}"
  status_code         = "${aws_api_gateway_method_response.LambdaWildcardGET_200.status_code}"
  response_parameters = {
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
    "method.response.header.Date"           = "integration.response.header.Date"
    "method.response.header.ETag"           = "integration.response.header.ETag"
    "method.response.header.Last-Modified"  = "integration.response.header.Last-Modified"
  }
  depends_on          = ["aws_api_gateway_integration.LambdaWildcardGET"]
}

# POST method -> Lambda Wildcard/{proxy}
resource "aws_api_gateway_method" "LambdaWildcardPOST" {
  rest_api_id      = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id      = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = "${var.with_cloudfront ? true : false}"
}

# integration between Lambda Wildcard resource's POST method and Lambda function (back-end)
resource "aws_api_gateway_integration" "LambdaWildcardPOST" {
  rest_api_id             = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id             = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method             = "${aws_api_gateway_method.LambdaWildcardPOST.http_method}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.MotrWebHandler.arn}:${aws_lambda_alias.MotrWebHandlerAlias.name}/invocations"
  integration_http_method = "POST"
  #credentials             = "${aws_iam_role.Lambda.arn}"
}


resource "aws_api_gateway_method_response" "LambdaWildcardPOST_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method         = "${aws_api_gateway_method.LambdaWildcardPOST.http_method}"
  status_code         = "200"
  response_models     = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Date"           = true
    "method.response.header.ETag"           = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
    "method.response.header.Last-Modified"  = true
  }
}

resource "aws_api_gateway_integration_response" "LambdaWildcardPOST_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.LambdaWildcard.id}"
  http_method         = "${aws_api_gateway_method.LambdaWildcardPOST.http_method}"
  status_code         = "${aws_api_gateway_method_response.LambdaWildcardPOST_200.status_code}"
  response_parameters = {
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
    "method.response.header.Date"           = "integration.response.header.Date"
    "method.response.header.ETag"           = "integration.response.header.ETag"
    "method.response.header.Last-Modified"  = "integration.response.header.Last-Modified"
  }
  depends_on          = ["aws_api_gateway_integration.LambdaWildcardPOST"]
}

####################################################################################################################################
# API GATEWAY ASSETS RESOURCES

# /assets resource
resource "aws_api_gateway_resource" "AssetsRoot" {
  rest_api_id = "${aws_api_gateway_rest_api.MotrWeb.id}"
  parent_id   = "${aws_api_gateway_rest_api.MotrWeb.root_resource_id}"
  path_part   = "assets"
}

# /assets/{item+} resource
resource "aws_api_gateway_resource" "AssetsWildcard" {
  rest_api_id = "${aws_api_gateway_rest_api.MotrWeb.id}"
  parent_id   = "${aws_api_gateway_resource.AssetsRoot.id}"
  path_part   = "{item+}"
}

# GET method -> /assets/{item+}
resource "aws_api_gateway_method" "AssetsWildcardGET" {
  rest_api_id        = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id        = "${aws_api_gateway_resource.AssetsWildcard.id}"
  http_method        = "GET"
  authorization      = "NONE"
  api_key_required   = "${var.with_cloudfront ? true : false}"
  request_parameters = {
    "method.request.path.item" = true
  }
}

# integration between ROOT resource's GET method and AWS S3 bucket service (back-end)
resource "aws_api_gateway_integration" "AssetsWildcardGET" {
  rest_api_id             = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id             = "${aws_api_gateway_resource.AssetsWildcard.id}"
  http_method             = "${aws_api_gateway_method.AssetsWildcardGET.http_method}"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/${aws_s3_bucket.MOTRS3Bucket.bucket}/assets/{object}"
  integration_http_method = "${aws_api_gateway_method.AssetsWildcardGET.http_method}"
  credentials             = "${aws_iam_role.APIGateway.arn}"
  request_parameters      = {
    "integration.request.path.object" = "method.request.path.item"
  }
}

resource "aws_api_gateway_method_response" "AssetsWildcardGET_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.AssetsWildcard.id}"
  http_method         = "${aws_api_gateway_method.AssetsWildcardGET.http_method}"
  status_code         = "200"
  response_parameters = {
    "method.response.header.Date"           = true
    "method.response.header.ETag"           = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
    "method.response.header.Last-Modified"  = true
    "method.response.header.Cache-Control"  = true
  }
}

resource "aws_api_gateway_integration_response" "AssetsWildcardGET_200" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.AssetsWildcard.id}"
  http_method         = "${aws_api_gateway_method.AssetsWildcardGET.http_method}"
  status_code         = "${aws_api_gateway_method_response.AssetsWildcardGET_200.status_code}"
  selection_pattern   = "200"
  response_parameters = {
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
    "method.response.header.Date"           = "integration.response.header.Date"
    "method.response.header.ETag"           = "integration.response.header.ETag"
    "method.response.header.Last-Modified"  = "integration.response.header.Last-Modified"
    "method.response.header.Cache-Control"  = "integration.response.header.Cache-Control"
  }
  content_handling    = "CONVERT_TO_BINARY"
  depends_on          = ["aws_api_gateway_integration.AssetsWildcardGET"]
}

resource "aws_api_gateway_method_response" "AssetsWildcardGET_404" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.AssetsWildcard.id}"
  http_method         = "${aws_api_gateway_method.AssetsWildcardGET.http_method}"
  status_code         = "404"
  response_parameters = {
    "method.response.header.Date"         = true
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "AssetsWildcardGET_404" {
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.AssetsWildcard.id}"
  http_method         = "${aws_api_gateway_method.AssetsWildcardGET.http_method}"
  status_code         = "${aws_api_gateway_method_response.AssetsWildcardGET_404.status_code}"
  selection_pattern   = "404"
  response_parameters = {
    "method.response.header.Date"         = "integration.response.header.Date"
    "method.response.header.Content-Type" = "integration.response.header.Content-Type"
  }
  depends_on          = ["aws_api_gateway_integration.AssetsWildcardGET"]
}

####################################################################################################################################
# API GATEWAY MOTH-MOCK RESOURCE

resource "aws_api_gateway_resource" "MothMock" {
  count       = "${var.mot_test_reminder_info_endpoint == "" ? 1 : 0}"
  rest_api_id = "${aws_api_gateway_rest_api.MotrWeb.id}"
  parent_id   = "${aws_api_gateway_rest_api.MotrWeb.root_resource_id}"
  path_part   = "mock-moth"
}

# GET method -> Lambda /mock-moth
resource "aws_api_gateway_method" "MothMockGET" {
  count         = "${var.mot_test_reminder_info_endpoint == "" ? 1 : 0}"
  rest_api_id   = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id   = "${aws_api_gateway_resource.MothMock.id}"
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = { "method.request.querystring.vrm" = true }
}

# integration between MothMock resource's GET method and Lambda function (back-end)
resource "aws_api_gateway_integration" "MothMockGET" {
  count                   = "${var.mot_test_reminder_info_endpoint == "" ? 1 : 0}"
  rest_api_id             = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id             = "${aws_api_gateway_resource.MothMock.id}"
  type                    = "MOCK"
  http_method             = "${aws_api_gateway_method.MothMockGET.http_method}"
  request_templates {
    "application/json" = <<EOF
{
    "statusCode":
    #if($input.params('vrm').contains("12345"))
        404
    #else
        200
    #end
}
EOF
  }
}

resource "aws_api_gateway_method_response" "MothMockGET_200" {
  count           = "${var.mot_test_reminder_info_endpoint == "" ? 1 : 0}"
  rest_api_id     = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id     = "${aws_api_gateway_resource.MothMock.id}"
  http_method     = "${aws_api_gateway_method.MothMockGET.http_method}"
  status_code     = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Date"           = true
    "method.response.header.ETag"           = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
    "method.response.header.Last-Modified"  = true
  }
}

resource "aws_api_gateway_method_response" "MothMockGET_404" {
  count               = "${var.mot_test_reminder_info_endpoint == "" ? 1 : 0}"
  rest_api_id         = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id         = "${aws_api_gateway_resource.MothMock.id}"
  http_method         = "${aws_api_gateway_method.MothMockGET.http_method}"
  status_code         = "404"
  response_parameters = {
    "method.response.header.Date"           = true
    "method.response.header.ETag"           = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
    "method.response.header.Last-Modified"  = true
  }
}

resource "aws_api_gateway_integration_response" "MothMockGET_404" {
  count             = "${var.mot_test_reminder_info_endpoint == "" ? 1 : 0}"
  rest_api_id       = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id       = "${aws_api_gateway_resource.MothMock.id}"
  http_method       = "${aws_api_gateway_method.MothMockGET.http_method}"
  status_code       = "${aws_api_gateway_method_response.MothMockGET_404.status_code}"
  selection_pattern = "404"
  depends_on        = ["aws_api_gateway_integration.MothMockGET"]
}

resource "aws_api_gateway_integration_response" "MothMockGET_200" {
  count             = "${var.mot_test_reminder_info_endpoint == "" ? 1 : 0}"
  rest_api_id       = "${aws_api_gateway_rest_api.MotrWeb.id}"
  resource_id       = "${aws_api_gateway_resource.MothMock.id}"
  http_method       = "${aws_api_gateway_method.MothMockGET.http_method}"
  status_code       = "${aws_api_gateway_method_response.MothMockGET_200.status_code}"
  selection_pattern = "200"
  response_templates {
    "application/json" = <<EOF
{
    #if($input.params('vrm').contains("WDD2040022A65"))
        "make": "MERCEDES-BENZ",
        "model": "C220 ELEGANCE ED125 CDI BLU-CY",
        "primaryColour": "Silver",
        "secondaryColour": "",
        "regNumber": "$input.params('vrm')",
        "yearOfManufacture": "2006",
        "motExpiryDate": "2016-11-26"
    #elseif($input.params('vrm').contains("YN13NTX"))
        "make": "HARLEY-DAVIDSON CVO ROAD GLIDE FLTRXSE2 ANV 13",
        "model": "",
        "primaryColour": "Multi-colour",
        "secondaryColour": "Multi-colour",
        "regNumber": "$input.params('vrm')",
        "yearOfManufacture": "2004",
        "motExpiryDate": "2017-12-01"
    #elseif($input.params('vrm').contains("LOY-500"))
        "make": "TOJEIRO BRISTOL 2.0L",
        "model": "1 DR MANUAL CONVERTIBLE SPORTS",
        "primaryColour": "Red",
        "secondaryColour": "",
        "regNumber": "$input.params('vrm')",
        "yearOfManufacture": "1999",
        "motExpiryDate": "2017-03-14"
    #else
        "make": "testMake",
        "model": "testModel",
        "primaryColour": "testPrimaryColour",
        "secondaryColour": "testSecondaryColour",
        "regNumber": "$input.params('vrm')",
        "yearOfManufacture": "1998",
        "motExpiryDate": "2019-12-23"
    #end
}
EOF
  }
  depends_on          = ["aws_api_gateway_integration.MothMockGET"]
}

####################################################################################################################################
# API GATEWAY DEPLOYMENT

resource "aws_api_gateway_deployment" "Deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.MotrWeb.id}"
  stage_name  = "${var.environment}"
  depends_on  = [ "aws_api_gateway_integration.LambdaRootGET"
                , "aws_api_gateway_integration.LambdaWildcardGET"
                , "aws_api_gateway_integration.LambdaWildcardPOST"
                , "aws_api_gateway_integration.AssetsWildcardGET"                
                , "aws_api_gateway_integration.MothMockGET"
                ]
}

####################################################################################################################################
# API KEY

resource "aws_api_gateway_api_key" "MotrWebApiKey" {
  # count      = "${var.with_cloudfront ? 1 : 0}"       # TEMP: because of known CF bug
  name       = "motr-web-${var.environment}-key"
  stage_key {
    rest_api_id = "${aws_api_gateway_rest_api.MotrWeb.id}"
    stage_name  = "${aws_api_gateway_deployment.Deployment.stage_name}"
  }
  depends_on = ["aws_api_gateway_deployment.Deployment"]
}

####################################################################################################################################
# API USAGE PLAN

resource "aws_cloudformation_stack" "MotrApiUsagePlan" {
  count         = "${var.with_cloudfront ? 1 : 0}"
  name          = "motr-cf-${var.environment}-up"
  parameters {
    UPName   = "motr-web-${var.environment}-up"
    ApiID    = "${aws_api_gateway_rest_api.MotrWeb.id}"
    ApiStage = "${aws_api_gateway_deployment.Deployment.stage_name}"
  }
  template_body = <<STACK
{
  "Parameters": {
    "UPName": {
      "Type": "String",
      "Description": "UsagePlan name"
    },
    "ApiID": {
      "Type": "String",
      "Description": "Associated API Gateway ID"
    },
    "ApiStage": {
      "Type": "String",
      "Description": "Associated API Gateway stage"
    }
  },
  "Resources": {
    "MotrWebUsagePlan": {
      "Type": "AWS::ApiGateway::UsagePlan",
      "Properties": {
        "UsagePlanName": { "Ref": "UPName" },
        "Description": "MotrWeb usage plan",
        "ApiStages": [
          {
            "ApiId": { "Ref": "ApiID" },
            "Stage": { "Ref": "ApiStage" }
          }
        ],
        "Throttle": {
          "RateLimit": 1000,
          "BurstLimit": 979
        }
      }
    }
  }
}
STACK
  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
  depends_on = ["aws_api_gateway_deployment.Deployment"]
}
