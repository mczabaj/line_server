(ns line-server.domain.file
  (:require [clojure.java.io :as io]
            [clojure.string :as s]
            [clojure.tools.logging :as log]
            [line-server.config :refer [env]]
            [ring.util.http-response :as response]
            [ring.util.http-status :as status]))

(defn file-name []
  (let [input-args (:arguments env)
        dev-file   (:file env)]
    (if input-args
      (first input-args)
      dev-file)))

(defn get-line [line-number]
  (println "command line args:" (first (:arguments env)))
  (log/debug "getting line from file: " file-name)
  (with-open [rdr (clojure.java.io/reader file-name)]
    (nth (line-seq rdr) line-number)))

(defn read-file [line-number]
  (log/debug "going to read the file now.")
  (try
    (response/ok (get-line line-number))
    (catch Exception e
      (log/error "exception: " e)
      (response/request-entity-too-large "line number cannot be beyond end of file"))))

(defn file-line [line-number]
  (log/debug "request for line: " line-number)
  (if (<= line-number 0)
    (response/request-entity-too-large "line number must be greater than 0")
    (read-file line-number)))
