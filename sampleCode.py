

def getAIResponse(prompt,model):
    import os
    from dotenv import load_dotenv
    load_dotenv(dotenv_path = '.env')
    
    SERVICE_ENDPOINT = os.environ['SERVICE_ENDPOINT']
    COMPARTMENT = os.environ['COMPARTMENT']
    
    import oci
    
    CONFIG_PROFILE = "DEFAULT"
    config = oci.config.from_file('~/.oci/config', CONFIG_PROFILE)
    
    generative_ai_inference_client = oci.generative_ai_inference.GenerativeAiInferenceClient(config=config,
                                                                                             service_endpoint=SERVICE_ENDPOINT)
    
    
    content = oci.generative_ai_inference.models.TextContent()
    content.text = prompt
    
    message = oci.generative_ai_inference.models.Message()
    message.role = "USER"
    message.content = [content]
    
    chat_request = oci.generative_ai_inference.models.GenericChatRequest()
    
    chat_request.messages = [message]
    
    chat_detail = oci.generative_ai_inference.models.ChatDetails()
    chat_detail.serving_mode = oci.generative_ai_inference.models.OnDemandServingMode(model_id=model)
    
    chat_detail.chat_request = chat_request
    chat_detail.compartment_id =COMPARTMENT
    
    chat_response = generative_ai_inference_client.chat(chat_detail)    
    
    output = chat_response.data.chat_response.choices[0].message.content[0].text
    
    print( output )

print("Function created...")
