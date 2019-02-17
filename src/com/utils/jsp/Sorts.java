package com.utils.jsp;

/* Sorts object to be passed to MySQL
 * 
  @param arr 	the array of random integers to be sorted 
  @param n		size of array
  @param method		the sorting method to be used
  @param ms		time taken
 *
 * Instantiated in home_response.jsp
 */
public class Sorts {
	public int arr[];
	public int n;
	public String method;
	public long ms;
	
	public Sorts(int[] arr, int n, String method){
		this.arr = arr;
		this.n = n;
		this.method = method;
	}
	/* Sort Timer */
	public long startTime() {
		long startTime = System.currentTimeMillis();
		
		return startTime;
	}
	public long endTime(long startTime) {
		long endTime = System.currentTimeMillis();
		
		return (endTime-startTime);
	}
	/* 
	 * 
	 * Sorting Methods
	 * 
	 */
	/* BubbleSort */
	public void bubbleSort() {
		int n = this.arr.length; 
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n-i-1; j++) {
                if (this.arr[j] > this.arr[j+1]) 
                { 
                    int temp = arr[j]; 
                    this.arr[j] = this.arr[j+1]; 
                    this.arr[j+1] = temp; 
                } 	
            }
        }
	}
	
	/* Merge for MergeSort */
	public void merge(int[] arr, int l, int mid, int r) {
        int n1 = mid - l + 1; 
        int n2 = r - mid; 
  
        int L[] = new int [n1]; 
        int R[] = new int [n2]; 
  
        for (int i=0; i<n1; ++i) 
            L[i] = arr[l + i]; 
        for (int j=0; j<n2; ++j) 
            R[j] = arr[mid + 1+ j]; 
  
        int i = 0, j = 0; 
  
        int k = l; 
        while (i < n1 && j < n2) 
        { 
            if (L[i] <= R[j]) 
            { 
                arr[k] = L[i]; 
                i++; 
            } 
            else
            { 
                arr[k] = R[j]; 
                j++; 
            } 
            k++; 
        } 

        while (i < n1) 
        { 
            arr[k] = L[i]; 
            i++; 
            k++; 
        } 
  
        while (j < n2) 
        { 
            arr[k] = R[j]; 
            j++; 
            k++; 
        }
	}
	/* Split for MergeSort */
	public void split(int l, int r) {
		if(l < r) {
			int mid = (l+r)/2;
			// recursive split to merge
			split(l, mid);
			split(mid+1, r);
			
			merge(this.arr, l, mid, r);
		}
	}
	
	/* Heapify for HeapSort */
	public void heapify() {
		
	}
}
