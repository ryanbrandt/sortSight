package com.utils.jsp;

/* Sorts object to be passed to MySQL
 * 
  @field arr -	the array of random integers to be sorted 
  @field n	-	size of array
  @field method	-	the sorting method to be used
  @field ms	-	time taken
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
	
	/* Merge for MergeSort 
	 * 
	 * @param arr -	array to be sorted
	 * @param l	-	leftmost index
	 * @param r	-	rightmost index
	 * @param mid -	midpoint of indices
	 * 
	 * */
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
	/* Split for MergeSort 
	 * 
	 * @param l	-	leftmost index
	 * @param r	-	rightmost index
	 * 
	 * */
	public void split(int l, int r) {
		if(l < r) {
			int mid = (l+r)/2;
			// recursive split to merge
			split(l, mid);
			split(mid+1, r);
			
			merge(this.arr, l, mid, r);
		}
	}
	
	/* Recursive heapify for HeapSort 
	 * 
	 * @param n -	size of array
	 * @param rootIndex	-	index of root of subtree
	 * 
	 * */
	public void heapify(int n, int rootIndex) {
		// get children of node, check if heap ordered
		int largest = rootIndex;
		int leftChild = 2*rootIndex + 1;
		int rightChild = 2*rootIndex + 2;
		
		if(leftChild < n && this.arr[leftChild] > this.arr[largest]) {
			largest = leftChild;
		}
		if(rightChild < n && this.arr[rightChild] > this.arr[largest]) {
			largest = rightChild;
		}
		// swap and recursively heapify subtree
		if(largest != rootIndex) {
			int tmp = this.arr[rootIndex];
			this.arr[rootIndex] = this.arr[largest];
			this.arr[largest] = tmp;
			
			heapify(n, largest);
			
		}
	}
	/* Heapsort */
	public void heapSort() {
		// heapify
		for(int i = this.n/2-1; i >= 0; i--) {
			heapify(this.n, i);
		}
		// sift down
		for(int j = this.n-1; j >= 0; j--) {
			int tmp = this.arr[0];
			arr[0] = this.arr[j];
			this.arr[j] = tmp;
			
			heapify(j, 0);
		}
		
	}
	
	/* partition array for QuickSort 
	 * 
	 * @param lo -	low index of array partition to be partitioned
	 * @param hi -	high index of array partition to be partitioned
	 * 
	 * */
	public int partition(int lo, int hi) {
		int pivot = this.arr[hi];
		int i = lo-1;
		
		for(int j = lo; j < hi; j++) {
			// smaller or equal to pivot, swap
			if(this.arr[j] <= pivot) {
				i++;
				
				int tmp = this.arr[i];
				this.arr[i] = this.arr[j];
				this.arr[j] = tmp;
			}
		}
		// swap i + 1 and high
		int tmp = this.arr[i+1];
		this.arr[i+1] = this.arr[hi];
		this.arr[hi] = tmp;
		
		return i+1;
	}
	/* Quicksort 
	 * 
	 * @param lo -	low index of partition to be sorted
	 * @param hi -	high index of partition to be sorted
	 * 
	 * */
	public void quickSort(int lo, int hi, int threshold) {
		// while can be partitioned, recursively sort below/above part
		if(lo < hi) {
			// optimized with insertion at threshold
			if(hi - lo < threshold) {
				insertionSort(lo, hi);
			} else {
				int part = partition(lo, hi);
				
				quickSort(lo, part-1, threshold);
				quickSort(part+1, hi, threshold);
			}
		}
	}
	
	/* Insertionsort 
	 * 
	 * @param lo -	default 0, included for optimized quicksort	
	 * @param hi -	default n-1, included for optimized quicksort
	 * 
	 * */
	public void insertionSort(int lo, int hi) {
		
		for(int i = lo; i < hi+1; i++) {
			
			int cur = this.arr[i];
			int j = i-1;
			// sort arr[0,i-1]
			while( j >= 0 && this.arr[j] > cur) {
				this.arr[j+1] = this.arr[j];
				j = j-1;
			}
			this.arr[j+1] = cur;
		}
	}
}
