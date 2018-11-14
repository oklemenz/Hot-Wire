package de.oklemenz.wire;

public class Point {

	public int x;
	public int y;
	
	public Point(int x, int y) {
		this.x = x;
		this.y = y;
	}
	
	public int hashCode() {
		return (x + "," + y).hashCode();
	}
	
	public boolean equals(Object object) {
		if (object instanceof Point) {
			Point p = (Point)object;
			return x == p.x && y == p.y;
		}
		return false; 
	}
	
	public String toString() {
		return "(" + x + "," + y + ")";
	}
}
