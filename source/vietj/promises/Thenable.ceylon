/*
 * Copyright 2013 Julien Viet
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"Thenable provides the base support for promises. This interface satisfies the
 [[Promised]] interface, to be used when a promise is needed instead of a thenable"
by("Julien Viet")
shared interface Thenable<out Value>
        satisfies Promised<Value>
            given Value satisfies Anything[] {

    M rethrow<M>(Exception e) {
        throw e;
    }

    "The then method from the Promise/A+ specification."
    shared Promise<Result> then_<Result>(
            <Callable<Result, Value>> onFulfilled,
            <Result(Exception)> onRejected = rethrow<Result>) {

        <Callable<Promise<Result>, Value>> onFulfilled2 = adaptResult<Result, Value>(onFulfilled);
        Promise<Result>(Exception) onRejected2 = adaptResult<Result, [Exception]>(onRejected);
        return then__(onFulfilled2, onRejected2);
    }

    Promise<M> rethrow2<M>(Exception e) {
        Deferred<M> deferred = Deferred<M>();
        deferred.reject(e);
        return deferred.promise;
    }

    "The then method from the Promise/A+ specification."
    shared formal Promise<Result> then__<Result>(
            <Callable<Promise<Result>, Value>> onFulfilled,
            <Promise<Result>(Exception)> onRejected = rethrow2<Result>);

    "Analog to Q finally (except that it does not consider the callback might return a promise"
    shared void always(Callable<Anything, Value|[Exception]> callback) {
        then_(callback, callback);
    }

}