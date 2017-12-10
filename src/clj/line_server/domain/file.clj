(ns line-server.domain.file
  (:require [clojure.java.io :as io]
            [clojure.string :as s]
            [clojure.tools.logging :as log]
            [line-server.config :refer [env]]
            [ring.util.http-response :as response]
            [ring.util.http-status :as status]))

(def file-name
  (if (empty? *command-line-args*)
    (:file env)
    (let [arg (s/split (first *command-line-args*) #"=")]
      (if (= "file" (first arg))
        (second arg)
        (:file env)))))

(defn get-line [line-number]
  (log/debug "getting line from file: " file-name)
  (with-open [rdr (clojure.java.io/reader file-name)]
    (nth (line-seq rdr) line-number)))

(defn read-file [line-number]
  (log/debug "going to read the file now.")
  (try
    (response/ok (get-line line-number))
    (catch Exception e
      (response/request-entity-too-large "line number cannot be beyond end of file"))))

(defn file-line [line-number]
  (log/debug "request for line: " line-number)
  (if (<= line-number 0)
    (response/request-entity-too-large "line number must be greater than 0")
    (read-file line-number)))
