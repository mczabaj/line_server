(ns user
  (:require 
            [mount.core :as mount]
            line-server.core))

(defn start []
  (mount/start-without #'line-server.core/repl-server))

(defn stop []
  (mount/stop-except #'line-server.core/repl-server))

(defn restart []
  (stop)
  (start))


