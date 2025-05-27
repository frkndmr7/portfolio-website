import json
import boto3
import decimal
import os

# Decimal türünü JSON formatına dönüştürmek için yardımcı sınıf
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return int(obj) if obj % 1 == 0 else float(obj)
        return super(DecimalEncoder, self).default(obj)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    # CORS Origin'i environment variable'dan al
    cors_origin = os.environ.get('CORS_ORIGIN', '*')
    
    # Sayfa kimliğini al veya varsayılan olarak 'homepage' kullan
    page_id = 'homepage'
    if event.get('queryStringParameters') and event['queryStringParameters'].get('pageId'):
        page_id = event['queryStringParameters']['pageId']
    
    try:
        # Mevcut sayıyı kontrol et
        response = table.get_item(Key={'pageId': page_id})
        
        # Eğer kayıt varsa sayıyı al, yoksa 0 olarak başlat
        current_count = 0
        if 'Item' in response:
            current_count = response['Item'].get('count', 0)
        
        # Sayıyı bir artır
        update_response = table.update_item(
            Key={'pageId': page_id},
            UpdateExpression='set #count = :newCount',
            ExpressionAttributeNames={'#count': 'count'},
            ExpressionAttributeValues={':newCount': current_count + 1},
            ReturnValues='UPDATED_NEW'
        )
        
        # CORS başlıkları ile yanıt döndür
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': cors_origin,
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'GET,OPTIONS'
            },
            'body': json.dumps({
                'count': update_response['Attributes']['count']
            }, cls=DecimalEncoder)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': cors_origin,
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'GET,OPTIONS'
            },
            'body': json.dumps({'error': str(e)})
        }