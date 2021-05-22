import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sorting_visulization/ColorConstants.dart';

class VisulizerProvider with ChangeNotifier {
  List<int> arrayOfBars = List();
  Duration mDuration = Duration(microseconds: 1000);

  var count = 0;
  var isRunning = false;

  // sizes
  var maxBars = 0;
  var maxHeight = 0;

  var algorithmType = 0;


  VisulizerProvider(int max, int height) {
    maxBars = max;
    maxHeight = height;
    getVisulizerBars(max, height);
  }



  void getVisulizerBars(int maxSize, int maxHeight) {

    arrayOfBars.clear();

    var tmpArray = List<int>();
    for (int i = 1; i <= maxSize; i++) {
      var height = ((i * maxHeight) / maxSize).toInt();
      tmpArray.add((height));
    }

    tmpArray.shuffle();
    arrayOfBars = tmpArray;
    notifyListeners();

  }


  void setAlgorithmType(int type){
    isRunning = false;
    algorithmType = type;
    resetBars();
    notifyListeners();
  }


  void resetBars(){
    getVisulizerBars(maxBars, maxHeight);
  }


  bool isSorted() {
    for (int i = 0; i < arrayOfBars.length - 1; i++) {
      if (arrayOfBars[i] > arrayOfBars[i + 1]) {
        return false;
      }
    }
    return true;
  }



  // swap
  swap(int i, int j) async {
    await Future.delayed(mDuration,(){
      int tmp = arrayOfBars[i];
      arrayOfBars[i] = arrayOfBars[j];
      arrayOfBars[j] = tmp;

      if(isSorted())
        isRunning = false;

      notifyListeners();
    });
  }



  start() async {
    isRunning = true;

    switch(algorithmType){
      case 0:
        mDuration = Duration(microseconds: 1000);
        await _quickSort(arrayOfBars, 0, arrayOfBars.length - 1);
      break;
      case 1:
        mDuration = Duration(microseconds: 1000);
        await _selectionSortVisualiser();
        break;
      case 2:
        mDuration = Duration(microseconds: 300);
        await _insertionSortVisualiser();
        break;
      case 3:
        mDuration = Duration(microseconds: 1000);
        await _mergeSortVisualiser(arrayOfBars, 0, arrayOfBars.length - 1);
        break;
      case 4:
        mDuration = Duration(microseconds: 1000);
        await _heapSortVisualiser(arrayOfBars);
        break;
      case 5:
        mDuration = Duration(microseconds: 1000);
        await _gnomeSortVisualiser();
        break;
      case 6:
        mDuration = Duration(microseconds: 1000);
        await _bubbleSort();
        break;

    }

  }



  // Bubble Sort -->  array using method
  _bubbleSort() async {

    for (int i = 0; i < arrayOfBars.length - 1; i++) {

      for (int j = 0; j < arrayOfBars.length - 1 - i ; j++) {

        if (arrayOfBars[j] > arrayOfBars[j + 1]) {

          int tmp = arrayOfBars[j];
          arrayOfBars[j] = arrayOfBars[j+1];
          arrayOfBars[j+1] = tmp;

          if(isRunning){
            await Future.delayed(const Duration(microseconds: 500), () {
              if(isSorted())
                isRunning = false;
              notifyListeners();
            });
          } else {
            return;
          }

        }

      }

    }

  }


  // Quick sort
  _quickSort(List<int> arrInt, int low, int high) async {
    if (low < high) {
      int pi = await quickPartition(arrInt, low, high);
      await _quickSort(arrInt, low, pi - 1);
      await _quickSort(arrInt, pi + 1, high);
    }
  }

  Future<int> quickPartition(List<int> arr, int low, int high) async {
    int pivot = arr[high];

    int i = (low - 1);
    for (int j = low; j <= high - 1; j++) {
      if (arr[j] < pivot) {
        i++;
        await swap(i, j);
      }
    }

    await swap(i + 1, high);
    return (i + 1);

  }


  // selection sort
  _selectionSortVisualiser() async {

    int minIndex;

    for (int i = 0; i < arrayOfBars.length - 1; i++) {
      minIndex = i;
      for (int j = i + 1; j < arrayOfBars.length; j++) {

        if(!isRunning) return;

        if (arrayOfBars[j] < arrayOfBars[minIndex]) {
          minIndex = j;
        }
      }

      await swap(i, minIndex);

    }
  }


  // Insertion sort
  _insertionSortVisualiser() async {

    int key, j;

    for (int i = 1; i < arrayOfBars.length; i++) {
      key = arrayOfBars[i];
      j = i - 1;

      print("print.....");

      while (j >= 0 && arrayOfBars[j] > key) {

        print("print.....2 $isRunning");

        if(!isRunning) return;

        await Future.delayed(mDuration, () {
          print("print.....3");
          arrayOfBars[j + 1] = arrayOfBars[j];
          notifyListeners();
        });

        j = j - 1;

      }

      await Future.delayed(mDuration, () {
        print("print.....4");
        arrayOfBars[j + 1] = key;
      });

    }

    isRunning = false;
    notifyListeners();

  }


  // Merge sort
  _mergeSortVisualiser(List<int> mergeArr, int low, int high) async {
    if (low < high) {

      if(!isRunning)
        return;

      int mid = (low + (high - low) / 2).toInt();
      await _mergeSortVisualiser(mergeArr, low, mid);
      await _mergeSortVisualiser(mergeArr, mid + 1, high);
      _updateArrayWithDelay(mergeArr);
      await merge(mergeArr, low, mid, high);

    }
  }

  merge(List<int> mergeArr, int low, int mid, int high) async {
    int i, j, k;
    int n1 = mid - low + 1;
    int n2 = high - mid;

    /* create temp arrays */
    List<int> L = [], R = [];

    /* Copy data to temp arrays L[] and R[] */
    for (i = 0; i < n1; i++)
      L.add(mergeArr[low + i]); //L[i] = mergeArr[low + i];
    for (j = 0; j < n2; j++)
      R.add(mergeArr[mid + 1 + j]); //R[j] = mergeArr[mid + 1 + j];

    i = 0;
    j = 0;
    k = low;
    while (i < n1 && j < n2) {

      if(!isRunning)
        return;

      if (L[i] <= R[j]) {
        mergeArr[k] = L[i];
        i++;
      } else {
        mergeArr[k] = R[j];
        j++;
      }
      await _updateArrayWithDelay(mergeArr);
      k++;
    }

    while (i < n1) {
      if(!isRunning) return;
      mergeArr[k] = L[i];
      i++;
      k++;
    }

    while (j < n2) {
      if(!isRunning) return;
      mergeArr[k] = R[j];
      j++;
      k++;
    }
  }

  _updateArrayWithDelay(List<int> updatedArr) async {
    await Future.delayed(mDuration, () {
        arrayOfBars = List.from(updatedArr);
        if(isSorted())
          isRunning = false;
        notifyListeners();
    });
  }


  //Heap sort
  _heapSortVisualiser(List<int> heapArr) async {
    int n = heapArr.length;

    // Build heap (rearrange array)
    for (int i = n ~/ 2 - 1; i >= 0; i--) await heapify(heapArr, n, i);

    // One by one extract an element from heap
    for (int i = n - 1; i >= 0; i--) {
      // Move current root to end
      int temp = heapArr[0];
      heapArr[0] = heapArr[i];
      heapArr[i] = temp;
      await _updateArrayWithDelay(heapArr);
      // call max heapify on the reduced heap
      await heapify(heapArr, i, 0);
    }
  }

  heapify(List<int> heapArr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if(!isRunning) return;

    // If left child is larger than root
    if (l < n && heapArr[l] > heapArr[largest]) largest = l;

    // If right child is larger than largest so far
    if (r < n && heapArr[r] > heapArr[largest]) largest = r;
    // If largest is not root
    if (largest != i) {
      int swap = heapArr[i];
      heapArr[i] = heapArr[largest];
      heapArr[largest] = swap;
      await _updateArrayWithDelay(heapArr);
      // Recursively heapify the affected sub-tree
      await heapify(heapArr, n, largest);
    }
  }


  ////Gnome sort
  _gnomeSortVisualiser() async {
    List<int> gnomeArr = List.from(arrayOfBars);
    int index = 0;

    while (index < gnomeArr.length) {
      if(!isRunning) return;
      if (index == 0) index++;
      if (gnomeArr[index] >= gnomeArr[index - 1])
        index++;
      else {
        int temp;
        temp = gnomeArr[index];
        gnomeArr[index] = gnomeArr[index - 1];
        gnomeArr[index - 1] = temp;
        await Future.delayed(const Duration(microseconds: 800), () {
            arrayOfBars = List.from(gnomeArr);
            notifyListeners();
        });
        index--;
      }
    }

    isRunning = false;
    notifyListeners();

  }


}
