(ns line-server.domain.file
  (:require [clojure.java.io :as io]
            [clojure.tools.logging :as log]
            [line-server.config :refer [env]]
            [ring.util.http-response :as response]
            [ring.util.http-status :as status]))

(defn get-line [line-number]
  (with-open [rdr (clojure.java.io/reader "resources/files/sample_500K.txt")]
    (nth (line-seq rdr) line-number)))

(defn read-file [line-number]
  (try
    (response/ok (get-line line-number))
    (catch Exception e
      (response/request-entity-too-large "line number cannot be beyond end of file"))))

(defn read-line [line-number]
  (log/debug "request for line: " line-number)
  (if (<= line-number 0)
    (response/request-entity-too-large "line number must be greater than 0")
    (read-file line-number)))
