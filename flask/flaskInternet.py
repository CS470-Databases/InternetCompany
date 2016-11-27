from flask import Flask
from flask import render_template
from flask import request, jsonify, redirect, session, url_for
import pymysql.cursors

app = Flask(__name__)

@app.route('/', methods=['POST', 'GET'])
def index():
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
        headers = []
        result = []
        # Connect to the database
        connection = pymysql.connect(host='198.207.210.75',
                                     user='dbconnect',
                                     password='Bingham470',
                                     db='ISP_MANAGEMENT',
                                     charset='utf8mb4',
                                     cursorclass=pymysql.cursors.DictCursor)
        try:
            with connection.cursor() as cursor:
                # Table, Column, Keyword
                # tried to use prepared statement for table and col
                #   but python wouldn't let me
                #TODO: create manual string scrubber
                sql = "SELECT `*` FROM `"+request.form['sel_Table'].upper()+"` WHERE `"+str(request.form['txt_ColumnName'])+"`=%s"
                cursor.execute(sql, (request.form['txt_Keyword']))
                result = cursor.fetchall()
                result = list(result)
                if len(result) > 0:
                    headers = list(result[0].keys())
        except Exception:
            #TODO: add error to template
            print('Couldnt find results...\n Check column name')
        finally:
            connection.close()

        return render_template('search.html',
                               table=request.form['sel_Table'],
                               headers=headers,
                               results=result)

@app.route('/edit/<table>')
def edit(table):
    row = session['editRow']
    #loads the template with row values
    return render_template('edit'+table+'.html', entry=row, table=table)

@app.route('/edit/post/<table>', methods=['POST'])
def editDatabase(table):
    #TODO: make a database query to edit the form based on request.form data
    print(table)
    print(request.form)
    return redirect('/')

@app.route('/create/new', methods=['GET', 'POST'])
def createNew():
    if request.method == 'GET':
        return render_template('createNew.html')
    elif request.method == 'POST':
        return render_template('createNew.html', table=request.form['sel_Table'])

@app.route('/create/new/customer', methods=['POST'])
def createCustomer():
# Connect to the database
    connection = pymysql.connect(host='198.207.210.75',
                                 user='dbconnect',
                                 password='Bingham470',
                                 db='ISP_MANAGEMENT',
                                 charset='utf8mb4',
                                 cursorclass=pymysql.cursors.DictCursor)
    try:
        with connection.cursor() as cursor:
            r = request.form
            # Create a new record
            sql = ("INSERT INTO `CUSTOMER` (`CustomerID`, `Cust_FirstName`, `Cust_LastName`, `BillingAddress`,"
              "`Cust_Email`, `ReferralSource`, `Username`,`Password`, `Cust_StartDate`)"
              "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)")
            #YYYY-MM-DD
            cursor.execute(sql, (r['txt_CustomerID'], r['txt_FirstName'],r['txt_LastName'],
                r['txt_BillingAddress'],r['txt_Email'],r['txt_ReferralSource'],r['txt_Username'],
                r['txt_Password'],r['txt_StartDate']))

        # connection is not autocommit by default. So you must commit to save
        # your changes.
        connection.commit()
    finally:
        connection.close()

    return redirect('/')

@app.route('/create/new/employee', methods=['POST'])
def createEmployee():
# Connect to the database
    connection = pymysql.connect(host='198.207.210.75',
                                 user='dbconnect',
                                 password='Bingham470',
                                 db='ISP_MANAGEMENT',
                                 charset='utf8mb4',
                                 cursorclass=pymysql.cursors.DictCursor)
    try:
        with connection.cursor() as cursor:
            r = request.form
            # Create a new record
            sql = ("INSERT INTO `EMPLOYEE` (`EmployeeID`, `Emp_FirstName`, `Emp_LastName`, `SSN`,"
                    "`DOB`, `Emp_Email`, `Emp_Address`,`Emp_Phone`, `Role`,`Salary`, `Emp_StartDate`,"
                    " `Emp_EndDate`,`ManagerID`, `DepartmentID`)"
                    "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
            #YYYY-MM-DD
            cursor.execute(sql, (r['txt_EmployeeID'], r['txt_FirstName'],r['txt_LastName'],r['txt_SSN'],
                r['txt_DOB'],r['txt_Email'],r['txt_Address'],r['txt_Phone'],r['txt_Role'],r['txt_Salary'],
                r['txt_StartDate'],r['txt_EndDate'],r['txt_ManagerID'],r['txt_DepartmentID']))

        # connection is not autocommit by default. So you must commit to save
        # your changes.
        connection.commit()
    finally:
        connection.close()

    return redirect('/')

@app.route('/create/new/ticket', methods=['POST'])
def createTicket():
# Connect to the database
    connection = pymysql.connect(host='198.207.210.75',
                                 user='dbconnect',
                                 password='Bingham470',
                                 db='ISP_MANAGEMENT',
                                 charset='utf8mb4',
                                 cursorclass=pymysql.cursors.DictCursor)
    try:
        with connection.cursor() as cursor:
            r = request.form
            # Create a new record
            sql = ("INSERT INTO `TICKET` (`TicketID`, `Category`, `TicketDate`, `TicketTime`,"
                    "`Solved`, `Problem`, `CustomerID`,`TicketOwnerID`)"
                    "VALUES (%s, %s, %s, %s, %s, %s, %s, %s)")
            #YYYY-MM-DD
            cursor.execute(sql, (r['txt_TicketID'], r['txt_Category'],r['txt_TicketDate'],r['txt_TicketTime'],
                r['chk_Solved'],r['txt_Problem'],r['txt_CustomerID'],r['txt_TicketOwnerID']))

        # connection is not autocommit by default. So you must commit to save
        # your changes.
        connection.commit()
    finally:
        connection.close()

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
