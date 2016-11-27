from flask import Flask
from flask import render_template
from flask import request, jsonify, redirect, session, url_for
app = Flask(__name__)
@app.route('/', methods=['POST', 'GET'])
def hello_world():
    '''
    Post:
      table- the table that was queried
      headers- a list of the table header values
      results- expecting a list of dictionaries where the dictionaries correspond to each row
               the dictionary keys are table headers and the values are the values for that row
      EX: [{FirstName: row1Val,
            LastName: row1Val,
            ...},
           {FirstName: row2Val,
            LastName: row2Val,
            ...}]
    '''
    if request.method == 'GET':
        return render_template('search.html')
    elif request.method == 'POST':
        #TODO: add sql query and send sql result to results
        return render_template('search.html',
                               table=request.form['sel_Table'],
                               headers=list(request.form.keys()),
                               results=[request.form])

@app.route('/edit/<table>')
def edit(table):
    row = session['editRow']
    row['CustomerID'] = '154165'
    #loads the template with row values
    return render_template('edit'+table+'.html', entry=row, table=table)

@app.route('/edit/post/<table>', methods=['POST'])
def editDatabase(table):
    #TODO: make a database query to edit the form based on request.form data
    print(table)
    print(request.form)
    return redirect('/')

def editPage(table, row):
    #saves the current row to session
    session['editRow'] = row
    return 'edit/'+table


app.jinja_env.globals.update(editPage=editPage)
app.jinja_env.globals.update(editDatabase=editDatabase)

#secret_key is required for session
app.secret_key = "b'\xccx\r\xcc\xb9\n\x01n\x13 -\x0f\x00\xd0\xc3Q\xbd\x16\xb4\xe3\x90\xd8_G'"
if __name__ == "__main__":
    app.run()
