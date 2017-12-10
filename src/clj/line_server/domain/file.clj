(ns line-server.domain.file
  (:require [clojure.java.io :as io]
            [clojure.tools.logging :as log]
            [line-server.config :refer [env]]))

(defn get-line [line-number]
  (log/debug "request for line: " line-number)

  (with-open [rdr (clojure.java.io/reader "resources/files/sample_500K.txt")]
         (nth (line-seq rdr) line-number)))
