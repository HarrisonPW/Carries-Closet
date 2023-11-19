# app.py

# Required imports
import os

from flask import Flask, request, jsonify
from firebase_admin import credentials, initialize_app, firestore
from datetime import date
import time

# Initialize Flask app
app = Flask(__name__)

# Initialize Firestore DB
cred = credentials.Certificate("/Users/puxuanwang/key.json")
default_app = initialize_app(cred)
db = firestore.client()
users_ref = db.collection('users')
requests_ref = db.collection('requests')
requestno_ref = db.collection('requestno')
inventory_ref = db.collection('inventory')

error_500 = """<!doctype html>
<html lang=en>
<title>500 Internal Server Error</title>
<h1>Internal Server Error</h1>
<p>The server encountered an unexpected condition that prevented it from fulfilling the request.
 The error has been logged.</p>"""


@app.route('/users/add', methods=['POST'])
@app.route('/users/create', methods=['POST'])
def add_user():
    """
        add_user() : Add document to Firestore collection with request body.
        Ensure you pass a custom ID as part of form body in post request,
        e.g. form={'id': '1', 'title': 'Write a blog post'}
    """
    try:
        # should include username, password, email, and permissions
        doc_id = request.form['id']
        users_ref.document(doc_id).set(request.form)
        return jsonify({"success": True, "id": doc_id}), 201
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/users', methods=['GET'])
@app.route('/users/list', methods=['GET'])
def get_user():
    """
        get_user() : Fetches documents from Firestore collection as JSON.
    """
    try:
        # Check if ID was passed to URL query
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        user_id = request.args.get('id')
        username = request.args.get('username')
        if user_id is None and username is not None:
            for doc in users_ref.stream():
                if doc.get('username') == username:
                    user_id = doc.id
        if user_id is not None:
            user = users_ref.document(user_id).get()
            return jsonify(user.to_dict()), 200
        else:
            all_users = [doc.to_dict() for doc in users_ref.stream()]
            return jsonify(all_users), 200
            # return jsonify("No user found matching given parameters."), 404
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/users/update', methods=['PUT', 'PATCH'])
@app.route('/users/edit', methods=['PUT', 'PATCH'])
def update_user():
    """
        update_user() : Update document in Firestore collection with request body.
        Ensure you pass a custom ID as part of form body in post request,
        e.g. form={'id': '1', 'title': 'Write a blog post today'}
    """
    try:
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        document_id = request.args.get('id')
        if document_id is None:
            username = request.args.get('username')
            for doc in users_ref.stream():
                if doc.get('username') == username:
                    document_id = doc.id
        if document_id is not None:
            users_ref.document(document_id).update(request.form)
            return jsonify({"success": True}), 200
        else:
            return jsonify("No user found matching given parameters."), 404
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/users/remove', methods=['DELETE'])
@app.route('/users/delete', methods=['DELETE'])
def delete_user():
    """
        delete_user() : Delete a document from Firestore collection.
    """
    try:
        if not check_permissions(request.args.get('requester'), 1):
            return jsonify("Insufficient permissions."), 403
        # Check for ID in URL query
        document_id = request.args.get('id')
        if document_id is None:
            username = request.args.get('username')
            for doc in users_ref.stream():
                if doc.get('username') == username:
                    document_id = doc.id
        if document_id is None:
            return jsonify("No user found matching given parameters."), 404
        users_ref.document(document_id).delete()
        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/requests/hygiene/create', methods=['POST'])
@app.route('/requests/hygiene/add', methods=['POST'])
def create_hygiene_request():
    try:
        # Expect: address, age, city, state, gender, item, notes, size, zip
        # Might be able to grab age, city, state, etc. from user profile information, so
        # later change to sending user in request instead of demographic information needing to be resubmitted 24/7
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        form_data = request.form.to_dict()
        form_data['date'] = date.today().strftime("%m/%d/%Y")  # MM/DD/YYYY
        form_data['type'] = 'hygiene'
        form_data['status'] = 'received'
        doc_id = requests_ref.add(form_data)
        return jsonify({"success": True, "id": doc_id[1].id}), 201
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/requests/clothing/create', methods=['POST'])
@app.route('/requests/clothing/add', methods=['POST'])
def create_clothing_request():
    try:
        # Expect: address, age, city, state, gender, item, notes, size, zip
        # Might be able to grab age, city, state, etc. from user profile information, so
        # later change to sending user in request instead of demographic information needing to be resubmitted 24/7
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        form_data = request.form.to_dict()
        form_data['date'] = date.today().strftime("%m/%d/%Y")  # MM/DD/YYYY
        form_data['type'] = 'clothing'
        form_data['status'] = 'received'
        doc_id = requests_ref.add(form_data)
        return jsonify({"success": True, "id": doc_id[1].id}), 201
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/requests/clothing', methods=['GET'])
@app.route('/requests/clothing/list', methods=['GET'])
def list_clothing_requests():
    try:
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        # Check for ID in request args
        document_id = request.args.get('id')
        requestno = request.args.get('requestno')
        if requestno is not None:
            for doc in requests_ref.stream():
                if doc.get('requestno') == requestno:
                    document_id = doc.id
                    break
        if document_id is None:
            all_requests = [doc.to_dict() for doc in requests_ref.stream()]
            removed_documents = []
            for i in range(len(all_requests)):
                request_document = all_requests[i]
                if request_document['type'].lower() != 'clothing':
                    removed_documents.append(request_document)
            for document in removed_documents:
                all_requests.remove(document)
            return jsonify(all_requests), 200
        else:
            return jsonify(requests_ref.document(document_id).get().to_dict()), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/requests/hygiene', methods=['GET'])
@app.route('/requests/hygiene/list', methods=['GET'])
def list_hygiene_requests():
    try:
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        # Check for ID in request args
        document_id = request.args.get('id')
        requestno = request.args.get('requestno')
        if requestno is not None:
            for doc in requests_ref.stream():
                if doc.get('requestno') == requestno:
                    document_id = doc.id
                    break
        if document_id is None:
            all_requests = [doc.to_dict() for doc in requests_ref.stream()]
            removed_documents = []
            for i in range(len(all_requests)):
                request_document = all_requests[i]
                if request_document['type'].lower() != 'hygiene':
                    removed_documents.append(request_document)
            for document in removed_documents:
                all_requests.remove(document)
            return jsonify(all_requests), 200
        else:
            return jsonify(requests_ref.document(document_id).get().to_dict()), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/requests', methods=['GET'])
@app.route('/requests/list', methods=['GET'])
def list_all_requests():
    try:
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        # Check for ID in request args
        document_id = request.args.get('id')
        requestno = request.args.get('requestno')
        if requestno is not None:
            for doc in requests_ref.stream():
                if doc.get('requestno') == requestno:
                    document_id = doc.id
                    break
        if document_id is None:
            all_requests = [doc.to_dict() for doc in requests_ref.stream()]
            all_requests = sorted(all_requests, key=lambda x: x['requestno'])
            return jsonify(all_requests), 200
        else:
            return jsonify(requests_ref.document(document_id).get().to_dict()), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/requests/remove', methods=['DELETE'])
@app.route('/requests/delete', methods=['DELETE'])
def remove_request():
    try:
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        # Check for ID in URL query
        document_id = request.args.get('id')
        requestno = request.args.get('requestno')
        if document_id is None and requestno is not None:
            for doc in requests_ref.stream():
                if doc.get('requestno') == requestno:
                    document_id = doc.id
                    break
        if document_id is not None:
            requests_ref.document(document_id).delete()
            return jsonify({"success": True}), 200
        else:
            return jsonify("No request found matching given parameters."), 404
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500


@app.route('/requests/edit', methods=['PUT', 'PATCH'])
@app.route('/requests/update', methods=['PUT', 'PATCH'])
def update_request():
    try:
        if not check_permissions(request.args.get('requester'), 1):
            return jsonify("Insufficient permissions."), 403
        document_id = request.args.get('id')
        requestno = request.args.get('requestno')
        if document_id is None and requestno is not None:
            for doc in requests_ref.stream():
                if doc.get('requestno') == requestno:
                    document_id = doc.id
                    break
        if document_id is not None:
            requests_ref.document(document_id).update(request.form)
            return jsonify({"success": True}), 200
        else:
            return jsonify("No request found matching given parameters."), 404

    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500

@app.route('/requestno', methods=['GET'])
def get_next_requestno():
    try:
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403
        document_id = 'requestnum'
        next_id = requestno_ref.document(document_id).get().to_dict()
        next_id = next_id['nextID']
        update_id = dict()
        update_id['nextID'] = next_id + 1
        requestno_ref.document('requestnum').update(update_id)

        return jsonify({'id': next_id}), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500
    
@app.route('/test', methods=['GET'])
def test():
    try:
        if not check_permissions(request.args.get('requester'), 0):
            return jsonify("Insufficient permissions."), 403

        return jsonify({'id': "You got it!"}), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500
    
@app.route('/inventory/add', methods=['POST'])
def add_inventory_item():
    try:
        if not check_permissions(request.args.get('requester'), 1):
            return jsonify("Insufficient permissions."), 403
        item = request.form['item']
        number = request.form['number']
        gender = request.form['gender']
        size = request.form['size']
        id = item +'-' + gender + '-' + size
        if inventory_ref.document(id).get().to_dict() is None:
            inventory_ref.document(id).set(request.form)
            return jsonify({"success": True}), 200
        else:
            update_number = dict()
            update_number['number'] = int(inventory_ref.document(id).get().to_dict()['number']) + int(number)
            inventory_ref.document(id).update(update_number)
            return jsonify({"success": True}), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500
    
@app.route('/inventory', methods=['GET'])
@app.route('/inventory/list', methods=['GET'])
def list_inventory_items():
    try:
        all_items = [doc.to_dict() for doc in inventory_ref.stream()]
        return jsonify(all_items), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500
    
@app.route('/inventory/update', methods=['PUT', 'PATCH'])
def update_inventory_item():
    try:
        item = request.args.get('item')
        number = request.args.get('number')
        gender = request.args.get('gender')
        size = request.args.get('size')
        id = item +'-' + gender + '-' + size
        if inventory_ref.document(id).get().to_dict() is None:
            return jsonify({"success": False}), 404
        else:
            if int(inventory_ref.document(id).get().to_dict()['number']) - int(number) < 0:
                return jsonify({"success": False, "message": "Not enough inventory"}), 404
            else:
                update_number = dict()
                update_number['number'] = int(inventory_ref.document(id).get().to_dict()['number']) - int(number)
                inventory_ref.document(id).update(update_number)
                return jsonify({"success": True}), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500
    
@app.route('/inventory/remove', methods=['DELETE'])
@app.route('/inventory/delete', methods=['DELETE'])
def remove_inventory_item():
    try:
        if check_permissions(request.args.get('requester'), 1):
            return jsonify("Insufficient permissions."), 403
        item = request.args.get('item')
        gender = request.args.get('gender')
        size = request.args.get('size')
        id = item +'-' + gender + '-' + size
        if inventory_ref.document(id).get().to_dict() is None:
            return jsonify({"success": False}), 404
        else:
            inventory_ref.document(id).delete()
            return jsonify({"success": True}), 200
    except Exception as e:
        print(f"An Error Occurred: {e}")
        return error_500, 500
    
        




# -1: Create user => No account required
#  0: Get/Update User, Get/Create/Delete Request, Get requestno => Account required, elevated permission not required
#  1: Delete User, Update Request => Account and elevated permissions required
def check_permissions(uid, perm):
    user_perms = -1
    for doc in users_ref.stream():
        if doc.id == uid:
            user_perms = 1 if str(doc.get('permissions')).lower() == 'true' else 0
            break
    if user_perms >= perm:
        return True
    else:
        return False


# Dev server setup
port = int(os.environ.get('PORT', 8083))
if __name__ == '__main__':
    app.run(threaded=True, host='0.0.0.0', port=port)
