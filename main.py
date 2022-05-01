from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route("/")
def main():
    pi = getpi()
    model = {"title": "Pi Calculator!", "pi": pi}
    return render_template('index.html', model=model)

def getpi():
    k = 1
    s = 0
    for i in range(1000000):
	    # even index elements are positive
        if i % 2 == 0:
            s += 4/k
        else:
		    # odd index elements are negative
            s -= 4/k
	    # denominator is odd
        k += 2

    return s
    


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))