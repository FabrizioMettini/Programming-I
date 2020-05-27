;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname Ejercicio_06) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; -------------------------------------
;; Ejercicio 6

(define MOSCA (bitmap "img/mosca.jpg")) ; Objeto a dibujar

(define ANCHO 700)                      ; Ancho de la escena
(define ALTO 700)                       ; Alto de la escena
(define FONDO (empty-scene ANCHO ALTO)) ; Escena vacia

(define DELTA 10)                        ; Distancia Delta
(define GAMMA (/ (image-width MOSCA) 2)) ; Distancia Gamma
(define SEGUNDOS-ENTRE-TICKS 1)          ; Segundos entre ticks

(define INICIAL (make-posn (/ ANCHO 2) (/ ALTO 2)))       ; Estado inicial
(define FINAL (make-posn -1 -1))                          ; Estado final
(define MENSAJE-FINAL (text "MOSCA ATRAPADA" 25 "black")) ; Mensaje al alcanzar el estado final

;; --------------------------------------
;; interpretarSimple: Estado -> Image
;; transforma el estado del sistema en una imagen a mostrar a través
;; de la cláusula to-draw.

(define (interpretarSimple p)
  (place-image MOSCA (posn-x p) (posn-y p) FONDO))

;; --------------------------------------
;; elegir-random: Number Number -> Number
;; Devuelve aleatoriamente uno de los dos números que recibe
;; como entrada.

(define (elegir-random a b)
  (if (= (random 2) 1) a b))

;; -------------------------------------
;; mover: Number -> Number
;; Devuelve el desplazamiento de la coordenada que recibe como entrada.

(define (mover n)
  (+ n (elegir-random DELTA (- DELTA))))

;; -------------------------------------
;; reloj: Estado -> Estado
;; Devuelve el nuevo estado a partir del desplazamiento
;; del estado anterior.

(define (reloj p)
  (make-posn (mover (posn-x p)) (mover (posn-y p))))

;; -------------------------------------
;; distancia: posn posn -> Number
;; Devuelve la distancia entre dos puntos del plano cartesiano.

(define (distancia p q)
  (sqrt (+ (sqr (- (posn-x p) (posn-x q)))
           (sqr (- (posn-y p) (posn-y q))))))

;; -------------------------------------
;; manejar-mouse: Estado Number Number MouseEvent -> Estado
;; dados el estado actual y un evento del mouse, devuelve
;; el nuevo estado de acuerdo al tipo de evento:
;; -"button-down": posición del mouse
;; - cualquier otro evento: no modifica el estado

(define (manejar-mouse p x y evento)
  (cond [(string=? evento "button-down")
         (if (< (distancia p (make-posn x y)) GAMMA) FINAL p)]
        [else p]))

;; -------------------------------------
;; final?: Estado -> Boolean
;; Predicado asociado a la clásula stop-when.
;; Devuelve si las coordenas x y del estado son las mismas que
;; las del estado final.

(define (final? p)
  (and (= (posn-x p) (posn-x FINAL))
       (= (posn-y p) (posn-y FINAL))))

;; -------------------------------------
;; interpretarFinal: Estado -> Image
;; transforma el estado del sistema en una imagen a mostrar cuando
;; el predicado asociado a la clásula stop-when devuelve #true.

(define (interpretarFinal p)
  (place-image MENSAJE-FINAL (/ ANCHO 2) (/ ALTO 2) FONDO))

;; -------------------------------------
;; Expresión big-bang:

(big-bang INICIAL
  [to-draw interpretarSimple]
  [on-tick reloj SEGUNDOS-ENTRE-TICKS]
  [on-mouse manejar-mouse]
  [stop-when final? interpretarFinal]
  )