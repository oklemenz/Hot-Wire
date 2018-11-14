package de.oklemenz.wire;

public class Square {

	public int x1;
	public int y1;
	public int x2;
	public int y2;
	
	public Square(int x1, int y1, int x2, int y2) {
		if (x1 <= x2) {
			this.x1 = x1;
			this.x2 = x2;
		} else {
			this.x1 = x2;
			this.x2 = x1;
		}
		if (y1 <= y2) {
			this.y1 = y1;
			this.y2 = y2;
		} else {
			this.y1 = y2;
			this.y2 = y1;
		}
	}

	public Square(int x1, int y1) {
		this.x1 = x1;
		this.x2 = this.x1 + 1;
		this.y1 = y1;
		this.y2 = this.y1 + 1;
	}
	
	public int hashCode() {
		return (x1 + "," + y1 + "," + x2 + "," + y2).hashCode();
	}
	
	public boolean equals(Object object) {
		if (object instanceof Square) {
			Square s = (Square)object;
			return x1 == s.x1 && y1 == s.y1 &&
				   x2 == s.x2 && y2 == s.y2;
		}
		return false; 
	}

	public String toString() {
		return "(" + x1 + "," + y1 + "," + x2 + "," + y2 + ")";
	}	
}