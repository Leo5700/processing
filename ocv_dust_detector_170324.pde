/**
 * Картинка с камеры
 * Background substraction
 * Звук
 * ocv_dust_detector
 */

import gab.opencv.*;
import processing.video.*;
import processing.sound.*;


Capture video;
OpenCV opencv;
SoundFile mp3file;

int cont_max, cont_min, cont, cont_s, n_s, cont_s_max, cont_s_warning;

float x, y, t, t0, dt; // TODO Разобраться -- кто какого типа, а то есть некоторые float-ы ненужные...

float[] X = new float[0];
float[] Y = new float[0];
float[] X_s = new float[0];
float[] Y_s = new float[0];


void setup() {
  surface.setSize(320, 240);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  
  // Какого-то фига kysh_1.mp3 не проигрывается. Вот это хрен знает почему.
  mp3file = new SoundFile(this, "clip_long.mp3"); // Почему-то совсем короткие .mp3 не воспроизводятся
  //mp3file = new SoundFile(this, "kysh_1.mp3");
  mp3file.amp(0.05); // Громкость
  
  video.start();
  
  frameRate(30);
  
  cont_max = 5; // Верхний порог чувствительности пыли (отсечка слишком крупных изменений)
  cont_min = 0; // Нижний порог чувствительности пыли
  cont = 0;
  x = 0; // Х для точек графика

  t0 = 0;
  dt = 5; // (с) Время квантования наблюдений
  
  cont_s = 0;
  
  n_s = 50; // Число сегментов линии квантованной пыли на оси Х TODO поправить на 0.01 ?
  
  cont_s_max = 100; // Верхний порог чувствительности квантованной пыли. Всё, что выше -- считается шумом от тряски камеры
  
  cont_s_warning = 5; // Всё, что между порогом предупреждения и порогом чувствительности -- сопровождается алармом
  
}


void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height);
    
    opencv.loadImage(video);
    opencv.updateBackground();
    opencv.dilate();
    opencv.erode();

    noFill();
    stroke(255, 0, 0);
    strokeWeight(3);
    
    mp3file.stop(); // Здесь вылезает "ERROR: /node/free: Node id -1 out of range" try catch не работает, непонятно чего перехватывать.
    cont = 0;
    for (Contour contour : opencv.findContours()) {
      cont += 1;
      contour.draw();
    }
    //println(cont); //
    
    
    // график
    stroke(0, 255, 0);
    strokeWeight(1);
    line(0, height/2 - cont_max, width, height/2 - cont_max); // Уровень
    strokeWeight(3);
    
    X = append(X, x);
    Y = append(Y, y);
    for (int i = 1; i < X.length; i++) { // Линия
      line(X[i], Y[i], X[i-1], Y[i-1]);
    }
    
    x += 1;
    if (x > width) {
      x = 0; 
      X = new float[0];
      Y = new float[0];
    }
    
    // текст
    y = height/2 - cont;
    text(cont, width/2, height/2 - height/4);
    
    // квантованный график (типа step)
    
    stroke(0, 0, 255);
    strokeWeight(1);
    line(0, height - cont_s_warning, width, height - cont_s_warning); // Уровень
    strokeWeight(3);
    
    cont_s += cont;
    if (millis() > t0 + dt*1000){
      Y_s = append(Y_s, height - cont_s); // Надо пересмотреть построение графиков -- хорошо, если можно число heihth отнять от массива иначе получается как-то глупо -- мы сначала вычитаем значения матрицы из высоты окна, чтобы график нормально строился, а потом производим обратную операцию чтобы напечатать текст
      X_s = append(X_s, width/n_s * Y_s.length);
      cont_s = 0;
      t0 = millis();
    }
    
    try {
    //println(X_s[X_s.length-1]); //
    
    // Здесь будет проверка уровня запылённости
    if (height-Y_s[Y_s.length-1] > cont_s_max) {
      text("STOP SHAKING CAMERA!", width/2, height/2 + height/4 + 13);
    }
    else if (height-Y_s[Y_s.length-1] > cont_s_warning){
      text("WARNING!", width/2, height/2 + height/4 + 26);
      // Здесь ещё надо проигрывать мелодию, причём так, чтобы она звучала не каждый кадр, а 1 раз в квант времени (сейчас это 5 секунд)
    }
    else{
    }
    
    
    
    if (X_s[X_s.length-1] > width) {
      cont_s = 0;
      X_s = new float[0];
      Y_s = new float[0];
     }
    }
    catch (Exception X_s){
      // Если массива ещё нет -- ничего...
    }

    
    for (int i = 1; i < X_s.length; i++) { // Линия квантованной пыли
      line(X_s[i], Y_s[i], X_s[i-1], Y_s[i-1]);
    }
    
    try {
    text(int(height - Y_s[Y_s.length-1]), width/2, height/2 + height/4);
    }
    catch (Exception Y_s){
      // Если массива ещё нет -- ничего...
    }
  

    // Звук
    if ( cont < cont_max && cont > cont_min ) {
      mp3file.play();
    }
    
    // TODO Запилить логирование (по cpu_clock) каждого квантованного уровня, причём, чтобы при нажатии на экран в лог добавлялось ; "Alarm!". И чтоб на экране возникала надпись "событие добавлено в лог"


      
    
  } 
}
