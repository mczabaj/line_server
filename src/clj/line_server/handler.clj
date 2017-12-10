(ns line-server.handler
  (:require [compojure.core :refer [routes wrap-routes]]
            [line-server.layout :refer [error-page]]
            [line-server.routes.home :refer [home-routes]]
            [line-server.routes.services :refer [service-routes]]
            [compojure.route :as route]
            [line-server.env :refer [defaults]]
            [mount.core :as mount]
            [line-server.middleware :as middleware]))

(mount/defstate init-app
                :start ((or (:init defaults) identity))
                :stop  ((or (:stop defaults) identity)))

(def app-routes
  (routes
    (-> #'home-routes
        (wrap-routes middleware/wrap-csrf)
        (wrap-routes middleware/wrap-formats))
    #'service-routes
    (route/not-found
      (:body
        (error-page {:status 404
                     :title "page not found"})))))


(defn app [] (middleware/wrap-base #'app-routes))
