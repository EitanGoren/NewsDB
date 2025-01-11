

/* [Word, [line, place in line, length],[line, place in line, length],...] */
import 'dart:collection';

Map<String, Set<List<int>>> splitFileToWordsList(List<String> fileLines) {
  if (fileLines.isEmpty) return {};

  Map<String, Set<List<int>>> wordsInfoMap = {};

  int l = 1;
  for (final line in fileLines) {
    List<String> words = line.split(' ');
    int w = 1;

    if (words.isEmpty) continue;

    for (final word in words) {
      String cleanWord = word.replaceAll('/n', '').replaceAll('/t', '').replaceAll(
          ',', '').replaceAll('.', '').toLowerCase();

      List<int> wordInfo = [l, w, cleanWord.length];
      if (wordsInfoMap[cleanWord] != null){
        var popo = wordsInfoMap[cleanWord] as Set<List<int>>;
        popo.add(wordInfo);
        wordsInfoMap[cleanWord] = popo;
      }
      else{
        var pipi = <List<int>>{};
        pipi.add(wordInfo);
        wordsInfoMap[cleanWord] = pipi;
      }
      w++;
    }
    l++;
  }
  return wordsInfoMap;
}

List<double> getArticleStatistics(List<String> fileLines){
  var wordsMap = splitFileToWordsList(fileLines);
  wordsMap.remove('');
  double avgWordsInLine = 0;
  double avgCharsInWord = 0;

  int l = 1;
  for(final line in fileLines){
    if (line.isEmpty) continue;
    avgWordsInLine = (avgWordsInLine + line.length) / l;
    l++;
  }
  l--;

  int sum = 0;
  for(final word in wordsMap.keys){
    sum += word.length;
  }
  avgCharsInWord = sum / wordsMap.length;

  return [double.parse(l.toString()), avgCharsInWord, avgWordsInLine, ];
}

LinkedHashMap getWordsFrequencyList(List<String> fileLines){
  var wordsMap = splitFileToWordsList(fileLines);
  wordsMap.remove('');
  Map<String,int> freqList = {};

  for(final word in wordsMap.keys){
    freqList[word] = wordsMap[word]!.length;
  }

  var sortedKeys = freqList.keys.toList(growable:false)
    ..sort((k1, k2) => freqList[k1]!.compareTo(freqList[k2]!));
  LinkedHashMap sortedMap = LinkedHashMap
      .fromIterable(sortedKeys, key: (k) => k, value: (k) => freqList[k]);
  return sortedMap;
}


