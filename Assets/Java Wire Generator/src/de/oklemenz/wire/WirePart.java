package de.oklemenz.wire;

import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;
import java.util.List;

public class WirePart {
	
	private static char HORIZONTAL = 'h';
	private static char VERTICAL   = 'v';
	private static char DIAGONAL   = 'd';
	
	/*
	 * h: horizontal (-)
	 * v: vertical (|)
	 * d: diagonal (\ or /) 
  
	 */
	public enum Kind {
		w1v2v, // 1|2|
		w1h2h, // 1-2-
		w1d2d, // 1\2/
		w1v2d, // 1|2/
		w1d2v, // 1\2|
		
		w1v3v, // 1|3| 
		w1h3h, // 1-3-
		w1d3d, // 1\3/
		w1h3d, // 1-3/
		w1d3h, // 1\3-
		
		w1v4v, // 1|4|
		w1h4h, // 1-4-
		w1d4d, // 1\4\
		w1h4v, // 1-4|
		w1v4h, // 1|4-
		w1d4v, // 1\4|
		w1v4d, // 1|4\
		w1d4h, // 1\4-
		w1h4d, // 1-4\
		
		w2h4h, // 2-4-
		w2d4d, // 2/4\
		w2h4d, // 2-4\
		w2d4h, // 2/4-
		
		w3v2v, // 3|2|
		w3h2h, // 3-2-
		w3d2d, // 3/2/
		w3h2v, // 3-2|
		w3v2h, // 3|2-
		w3d2v, // 3/2|
		w3v2d, // 3|2/
		w3d2h, // 3/2-
		w3h2d, // 3-2/
		
		w3v4v, // 3|4|
		w3d4d, // 3/4\
		w3v4d, // 3|4\
		w3d4v, // 3/4|
	}
	
	public enum End {
		e1h, // 1-
		e1d, // 1\
		e1v, // 1|
		e2h, // 2-
		e2d, // 2/
		e2v, // 2|
		e3h, // 3-
		e3d, // 3/		
		e3v, // 3|
		e4h, // 4-
		e4d, // 4\
		e4v, // 4|
	}

	public static int[][] xMove = { {  0, -1,  0, -1 },
							     	{  1,  0,  1,  0 },
								    {  0, -1,  0, -1 },
								    {  1,  0,  1,  0 } };

	public static int[][] yMove = { {  0,  0,  1,  1 },
							  	    {  0,  0,  1,  1 },
							  	    { -1, -1,  0,  0 },
							  	    { -1, -1,  0,  0 } };
	
	private Kind kind;
	private End start;
	private End end;
	
	private Point startPoint;
	private Point endPoint;
	private Square square;
	
	private int left   = 0;
	private int right  = 0;
	private int top    = 0;
	private int bottom = 0;
	
	private int startX = 0;
	private int startY = 0;

	private int endX   = 0;
	private int endY   = 0;
	
	private boolean valid;
	private boolean used;
	
	public WirePart(Kind kind, End start, int x, int y) {
		this.kind = kind;
		this.startX = x;
		this.startY = y;
		this.start = getEnd1(kind);
		if (this.start == start) {
			this.end = getEnd2(kind);
		} else {
			this.end = this.start;
			this.start = getEnd2(kind);
			if (this.start != start) {
				throw new RuntimeException();
			}
		}
		int startPosition = getPosition(this.start);
		int endPosition   = getPosition(this.end);
		int moveX = xMove[startPosition-1][endPosition-1];
		int moveY = yMove[startPosition-1][endPosition-1];
		if (moveX == 0 && moveY == 0) {
			throw new RuntimeException();
		}
		endX = startX - moveX;
		endY = startY + moveY;
		if (startPosition == 1 || startPosition == 3) {
			left  = startX;
			right = left + 1;
		} else if (startPosition == 2 || startPosition == 4) {
			right = startX;
			left  = right - 1;
		}
		if (startPosition == 1 || startPosition == 2) {
			top    = startY;
			bottom = top + 1;
		} else if (startPosition == 3 || startPosition == 4) {
			bottom = startY;
			top    = bottom - 1;
		}
	}
	
	public WirePart(Kind kind, End start, WirePart previousWirePart) {
		this(kind, start, previousWirePart.getEndX(), previousWirePart.getEndY());
	}	
	
	public List<WirePart> getFittingWireParts() {
		List<WirePart> wireParts = new ArrayList<WirePart>();
		int position = getPosition(end);
		char direction = getDirection(end);
		for (Kind kind : Kind.values()) {
			End start = getEnd1(kind);
			int newPosition = getPosition(start);
			char newDirection = getDirection(start);
			if (combinationAllowed(position, direction, newPosition, newDirection)) {
				wireParts.add(new WirePart(kind, start, this));
			}
			start = getEnd2(kind);
			newPosition = getPosition(start);
			newDirection = getDirection(start);
			if (combinationAllowed(position, direction, newPosition, newDirection)) {
				wireParts.add(new WirePart(kind, start, this));
			}
		}
		return wireParts;
	}

	
	private boolean combinationAllowed(int position, char direction, int newPosition, char newDirection) {
		if (position != newPosition && direction == newDirection) {
			if (position + newPosition == 5) {
				return true;
			}
			switch (position) {
				case 1:
					return (direction == HORIZONTAL && newPosition == 2) || (direction == VERTICAL && newPosition == 3);
				case 2:
					return (direction == HORIZONTAL && newPosition == 1) || (direction == VERTICAL && newPosition == 4);
				case 3:
					return (direction == HORIZONTAL && newPosition == 4) || (direction == VERTICAL && newPosition == 1);
				case 4:
					return (direction == HORIZONTAL && newPosition == 3) || (direction == VERTICAL && newPosition == 2);
			}
		}
		return false;
	}
	
	public End getStart() {
		return start;
	}

	public End getEnd() {
		return end;
	}
	
	public Kind getKind() {
		return kind;
	}
	
	public int getStartX() {
		return startX;
	}

	public int getStartY() {
		return startY;
	}

	public int getEndX() {
		return endX;
	}

	public int getEndY() {
		return endY;
	}
	
	public int getLeft() {
		return left;
	}

	public int getRight() {
		return right;
	}

	public int getTop() {
		return top;
	}

	public int getBottom() {
		return bottom;
	}
	
	public Point getStartPoint() {
		if (startPoint == null) {
			startPoint = new Point(startX, startY);
		}
		return startPoint;
	}

	public Point getEndPoint() {
		if (endPoint == null) {
			endPoint = new Point(endX, endY);
		}
		return endPoint;
	}
	
	public Square getSquare() {
		if (square == null) {
			square = new Square(left, top, right, bottom);
		}
		return square;
	}
	
	public boolean isValid() {
		return valid;
	}
	
	public void setValid() {
		this.valid = true;
	}

	public boolean isUsed() {
		return used;
	}
	
	public void setUsed() {
		this.used = true;
	}
	
	public void draw(Graphics g, int offsetX, int offsetY) {
		char startDirection = getDirection(start);
		char endDirection   = getDirection(end);
		int drawStartX = Wire.GRID_X * startX + Wire.BORDER_LEFT - offsetX;
		int drawStartY = Wire.GRID_Y * startY + Wire.BORDER_TOP - offsetY;
		int drawEndX   = Wire.GRID_X * endX   + Wire.BORDER_LEFT - offsetX;
		int drawEndY   = Wire.GRID_Y * endY   + Wire.BORDER_TOP - offsetY;
		int drawLeft   = Wire.GRID_X * left   + Wire.BORDER_LEFT - offsetX;
		int drawTop    = Wire.GRID_Y * top    + Wire.BORDER_TOP - offsetY;
		g.setColor(Color.BLACK);
		if (kind == Kind.w3v2h) {
			g.drawArc(drawLeft, drawTop, 2*Wire.GRID_X, 2*Wire.GRID_Y, 90, 90);
		} else if (kind == Kind.w1h4v) {
			g.drawArc(drawLeft-Wire.GRID_X, drawTop, 2*Wire.GRID_X, 2*Wire.GRID_Y, 0, 90);
		} else if (kind == Kind.w1v4h) {
			g.drawArc(drawLeft, drawTop-Wire.GRID_Y, 2*Wire.GRID_X, 2*Wire.GRID_Y, 180, 90);
		} else if (kind == Kind.w3h2v) {
			g.drawArc(drawLeft-Wire.GRID_X, drawTop-Wire.GRID_Y, 2*Wire.GRID_X, 2*Wire.GRID_Y, 270, 90);
		} else if (kind == Kind.w1h3h || kind == Kind.w1d3d || kind == Kind.w1h3d || kind == Kind.w1d3h) {
			g.drawArc(drawLeft-Wire.GRID_X/2, drawTop, Wire.GRID_X, Wire.GRID_Y, 270, 180);				
		} else if (kind == Kind.w1v2v || kind == Kind.w1d2d || kind == Kind.w1v2d || kind == Kind.w1d2v) {
			g.drawArc(drawLeft, drawTop-Wire.GRID_Y/2, Wire.GRID_X, Wire.GRID_Y, 180, 180);
		} else if (kind == Kind.w2h4h || kind == Kind.w2d4d || kind == Kind.w2h4d || kind == Kind.w2d4h) {
			g.drawArc(drawLeft+Wire.GRID_X/2, drawTop, Wire.GRID_X, Wire.GRID_Y, 90, 180);
		} else if (kind == Kind.w3v4v || kind == Kind.w3d4d || kind == Kind.w3v4d || kind == Kind.w3d4v) {				
			g.drawArc(drawLeft, drawTop+Wire.GRID_Y/2, Wire.GRID_X, Wire.GRID_Y, 0, 180);
		} else if ((startDirection == endDirection && kind != Kind.w1h3h && kind != Kind.w1v2v && kind != Kind.w2h4h && kind != Kind.w3v4v) ||  
   			      (( startDirection == HORIZONTAL || startDirection == VERTICAL) && endDirection   == DIAGONAL) ||
				  (( endDirection   == HORIZONTAL || endDirection   == VERTICAL) && startDirection == DIAGONAL)) {
			g.drawLine(drawStartX, drawStartY, drawEndX, drawEndY);
		} else {
			throw new RuntimeException();
		}
	}
	
	public String toString() {
		return start.toString() + "-" + end.toString();
	}
	
	public static End getEnd1(Kind kind) {
		return getEnd(kind.toString().substring(1, 3));
	}

	public static End getEnd2(Kind kind) {
		return getEnd(kind.toString().substring(3, 5));
	}
	
	public static int getPosition(End end) {
		return Integer.parseInt(end.toString().substring(1, 2));
	}
	
	public static char getDirection(End end) {
		return end.toString().charAt(2);
	}
	
	public static End getEnd(String end) {
		return End.valueOf("e" + end);
	}
	
	public static End getEnd(int position, char direction) {
		return End.valueOf("e" + position + direction);
	}

	public static Kind getKind(int position1, char direction1, int position2, char direction2) {
		return Kind.valueOf("w" + position1 + direction1 + position2 + direction2);
	}
	
	public static boolean kindExists(int position1, char direction1, int position2, char direction2) {
		try {
			return Kind.valueOf("w" + position1 + direction1 + position2 + direction2) != null;
		} catch(IllegalArgumentException e) {
			return false;	
		}		
	}
}
