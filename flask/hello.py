from flask import Flask
from flask import render_template
from flask import request, jsonify, redirect
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
    return render_template('edit'+table+'.html')

def editPage(table, row):
    return 'edit/'+table

app.jinja_env.globals.update(editPage=editPage)


if __name__ == "__main__":
    app.run()
