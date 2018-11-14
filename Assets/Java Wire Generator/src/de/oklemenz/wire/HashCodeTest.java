package de.oklemenz.wire;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

public class HashCodeTest {
	
	public static void main(String[] args) {
		
		int seed = 2283313;
		int level = 10;
		String hashCodeString = "";
		for (int j = 1 ; j <= level; j++) {
			hashCodeString = "";
			for (int i = 0; i < 256; i++) {
				char c = (char)i;
				int hashCode = Math.abs(("" + c+c+c+c + "" + (j * seed) + "" + c+c+c+c).hashCode());
				hashCodeString += hashCode;
			}
			System.out.println(hashCodeString);
		}

		int length = 11;
		int[] order = new int[length]; 
		for (int i = 0; i < length; i++) {
			order[i] = Integer.parseInt(hashCodeString.substring(i, i+1));
		}
		order = radixSort(order);
		for (int i = 0; i < length; i++) {
			System.out.println(order[i]);
		}
	}
	
	@SuppressWarnings("unchecked")
	public static int[] radixSort(int[] order) {
		int[] newOrder = new int[order.length];
		List<Integer>[] count = (List<Integer>[])Array.newInstance(ArrayList.class, order.length); 
		for (int i = 0; i < order.length; i++) {
			if (count[order[i]] == null) {
				count[order[i]] = new ArrayList<Integer>();
			}
			count[order[i]].add(i);
		}
		int c = 0;
		for (int i = 0; i < count.length; i++) {
			if (count[i] != null) {
				for (int j : count[i]) {
					newOrder[c++] = j;
				}
			}
		}
		return newOrder; 
	}
}
